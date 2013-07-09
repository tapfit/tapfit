require './lib/resque_job'

class GoRecess < ResqueJob

  @lat = 39.136111100000001
  @lon = -84.503055599999996

  def self.perform(page, rerun, date)

    if rerun
      GoRecess.get_classes(page, date, true)      
    else
      GoRecess.get_classes(page, date, false)   
    end
    
  end
  
  def self.get_classes(page, date, get_pages)
    response = RestClient.post 'https://www.gorecess.com/search', 
      {
        :search => 
        { 
          :category_ids => [1, 2, 3, 4, 5, 9, 11, 14], 
          :radius => "25", 
          :type => "class",
          :date => date.to_date, 
          :page => page, 
          :latitude => @lat,  
          :longitude => @lon 
        } 
      }
  
    parsed_json = JSON.parse(response.to_str)  
    GoRecess.save_classes_to_database(parsed_json)

    if get_pages
      total_pages = parsed_json["pagination"]["total_pages"]
      
      page += 1
      while page < total_pages
        Resque.enqueue(GoRecess, page, false, date)
        page += 1
      end
    end
  end

  def self.save_classes_to_database(parsed_json)
    parsed_json["scheduled_classes"].each do |gym|
      doc = Nokogiri::HTML(open("https://www.gorecess.com/locations/" + parsed_json["location"]["id"]))
      description = doc.xpath("//meta[@name='description']/@content").first.value
      phone_number = doc.xpath("//div[@itemprop='telephone']").first.content
      puts "className: #{gym["class_type"]["name"]}, phone_number: #{phone_number}, description: #{description}"
      puts "locationName: #{gym["location"]["name"]}"
    end
  end
end
