require './lib/resque_job'
require 'nokogiri'
require 'open-uri'
require './lib/major_cities'
require 'net/http'
Dir["./lib/crawler_validation/*.rb"].each { |file| require file }

class GoRecess < ResqueJob

  @source = "goRecess"
  @locations = LatLon.get_lat_lon

=begin
  @locations = [{:lat => 39.110874, :lon => -84.5157}, {:lat => 41.882863, :lon => -87.628812}, {:lat => 37.77493, :lon => -122.419416}, {:lat => 40.714353, :lon => -74.005973}, {:lat => 38.627003, :lon => -90.199404}, {:lat => 33.835293, :lon => -117.914504}, {:lat => 34.052234, :lon => -118.243685}, {:lat => 29.760193, :lon => -95.36939}, {:lat => 39.952335, :lon => -75.163789}, {:lat => 33.448377, :lon => -112.074037}]
=end

  def self.perform(page, location, date)
    
    return

    if Date.today != Date.parse(date.to_s)
      return
    end

    if !!location == location && location == true
      puts "location count: @locations.length"
      @locations.each do |loc|
        Resque.enqueue(self, 1, loc, date)
      end
    elsif page == 1     
      if !location["lat"].nil?
        loc = {}
        loc[:lat] = location["lat"]
        loc[:lon] = location["lon"]
        GoRecess.get_locations(page, date, loc)
      else
        GoRecess.get_locations(page, date, location)
      end
    else
      GoRecess.get_classes_for_location(page, location, date)   
    end
    
  end
  
  def self.get_classes_for_location(url, place_id, date)
    date = DateTime.parse(date.to_s)
    params = 
    {
      :search =>
      {
        :date => date.strftime("%Y-%m-%d"),
        :type => "scheduled_classes"
      },
      :offset => 240,
      :schedule_url => "#{url}#schedule",
      'X-Requested-With' => 'XMLHttpRequest'
    }

    call_url = "https://www.gorecess.com#{url}/schedule"
    headers = { 'X-Requested-With' => 'XMLHttpRequest' }
    puts params
    puts call_url 

    response = RestClient.get(call_url, params)  
    
    parsed_json = JSON.parse(response.to_str)

    GoRecess.save_classes_to_database(parsed_json, place_id)
  end

  def self.get_locations(page, date, location)
    params = 
      {
        :search => 
        { 
          :category_ids => [1, 2, 3, 4, 5, 9, 11, 14], 
          :radius => "50", 
          :type => "providers",
          :date => date.to_date.strftime("%Y-%m-%d"), 
          :page => page, 
          :latitude => location[:lat],  
          :longitude => location[:lon]
        } 
      }

      response = RestClient.post 'https://www.gorecess.com/search', params

      parsed_json = JSON.parse(response.to_str)  

      total_pages = parsed_json["pagination"]["total_pages"]

      providers = parsed_json["providers"]

      providers.each do |loc|
        place_id = self.get_location_info_and_save(loc)
        if !place_id.nil?
          puts loc["url"]
          Resque.enqueue(GoRecess, loc["url"], place_id, date)
        end
      end
      if page == 1 
        page += 1
        while page < total_pages
          self.get_locations(page, date, location)          
          page += 1
        end
      end
  end

  def self.get_classes(page, date, location)

      params = 
      {
        :search => 
        { 
          :category_ids => [1, 2, 3, 4, 5, 9, 11, 14], 
          :radius => "50", 
          :type => "class",
          :date => date.to_date.strftime("%Y-%m-%d"), 
          :page => page, 
          :latitude => location[:lat],  
          :longitude => location[:lon]
        } 
      }
      
      puts params

      response = RestClient.post 'https://www.gorecess.com/search', params

      parsed_json = JSON.parse(response.to_str)  
      GoRecess.save_classes_to_database(parsed_json)

      total_pages = parsed_json["pagination"]["total_pages"]
        
      if page == 1

        page += 1
        while page < total_pages
          Resque.enqueue(GoRecess, page, location, date)
          page += 1
        end
      end
  end

  def self.save_classes_to_database(parsed_json, place_id)
    parsed_json["scheduled_classes"].each do |gym|
      
      if place_id.nil?
        MailerUtils.write_error("Gym ID: #{gym_id}", "couldn't save the gym's info", @source)
        break
      else
        GoRecess.get_class_info_and_save(gym, place_id) 
      end
    end
  end

  def self.get_class_info_and_save(json, place_id)
    opts = {}
    opts[:place_id] = place_id
    opts[:name] = json["class_type"]["name"] 
    opts[:tags] = json["class_type"]["tags"]
    date = Time.parse(json["date"])
    opts[:start_time] = date + json["starts"]
    opts[:end_time] = date + json["ends"]
    opts[:price] = json["price"]
    opts[:instructor] = json["staff"]["name"]
    opts[:source] = @source
    process_class = ProcessClass.new(opts)
    process_class.save_to_database(@source)
  end

  def self.get_location_info_and_save(location)
    gym_id = location["id"]
    place_id = ProcessLocation.get_place_id(@source, gym_id)
    if place_id.nil?
      gym_id = location["id"]
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

      address = {}
      address[:line1] = location["address"]
      address[:city] = location["city"]
      address[:state] = location["region"]
      address[:zip] = location["postal_code"]
      address[:lat] = location["latitude"]
      address[:lon] = location["longitude"]

      opts = {}
      opts[:name] = location["name"]
      opts[:address] = address
      opts[:tags] = location["tags"]
      opts[:phone_number] = phone_number
      opts[:source] = @source
      opts[:source_id] = gym_id

      if !description.nil?
        opts[:source_description] = description
      end
      
      process_location = ProcessLocation.new(opts)
      place_id = process_location.save_to_database(@source)
    end
    return place_id
  end
end
