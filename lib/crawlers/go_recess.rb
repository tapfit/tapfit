require './lib/resque_job'
require 'nokogiri'
require 'open-uri'
require './lib/crawler_validation/process_location'

class GoRecess < ResqueJob

  @source = "goRecess"
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
      location = gym["location"]
      gym_id = location["id"]
      puts gym_id
      output = `phantomjs ./lib/phantomjs/get_page.js https://www.gorecess.com/locations/#{gym_id}`
      doc = Nokogiri::HTML(output)
      desc_xml = doc.xpath("//meta[@name='description']/@content").first
      if !desc_xml.nil?
        description = desc_xml.value
      end
      num_xml = doc.xpath("//div[@itemprop='telephone']").first
      if !num_xml.nil?
        phone_number = num_xml.content
      end
      
      address = {:line1 => location["address"], :city => location["city"], :state => location["region"], :zip => location["postal_code"], :latitude => location["latitude"], :longitude => location["longitude"]}

      opts = {:name => location["name"], :address => address, :tags => location["tags"], :phone_number => phone_number, :source => @source, :source_id => gym_id}
      if !description.nil?
        opts.merge!(:source_description => description)
      end
      
      process_location = ProcessLocation.new(opts)

      process_location.save_to_database(@source)
      puts "className: #{gym["class_type"]["name"]}, phone_number: #{phone_number}, description: #{description}"
      puts "locationName: #{gym["location"]["name"]}"
    end
  end
end
