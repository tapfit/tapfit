require 'nokogiri'
Dir["./lib/crawler_validation/*.rb"].each { |file| require file }

class SnapFitness < ResqueJob

  @source = "snapfitness"

  def self.perform(page, location, date)
    
    

  end

  def self.get_locations
    
    url = "http://www.snapfitness.com/gyms/getLocations"

    params =
    {
      :search => 45202,
      :latitude => 39.1031971,
      :longitude => -84.5064881000,
      :radius => 3000
    }

    response = RestClient.post(url, params)

    response = response.to_s.gsub("<textarea>", "").gsub("undefined</textarea>", "").gsub("</textarea>", "")

    parsed_json = JSON.parse(response)

    puts parsed_json["locations"].count

    parsed_json["locations"].each do |location|
      
      if ProcessLocation.get_place_id(@source, location["locationID"]).nil? 
      
        address = {}
        address[:line1] = location["address1"]
        address[:line2] = location["address2"]
        address[:city] = location["city"]
        address[:state] = location["state"]
        address[:zip] = location["postalCode"]
        address[:lat] = location["latitude"]
        address[:lon] = location["longitude"]

        url = Nokogiri::HTML(location["infoWindow"]).search("a").first["href"]
        opts = {}
        opts[:name] = "Snap Fitness"
        opts[:address] = address
        opts[:url] = url
        opts[:phone_number] = location["phone"]
        opts[:category] = Category::Gym
        opts[:tags] = [Category::Gym, "24 Hour", Category::Strength, Category::Cardio]
        opts[:source] = @source
        opts[:source_id] = location["locationID"]
            
        process_location = ProcessLocation.new(opts)
        process_location.save_to_database(@source)
      
      end
      
    end

  end

end
