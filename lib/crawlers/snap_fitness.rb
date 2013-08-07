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
      :radius => 20
    }

    response = RestClient.post(url, params)

    response = response.to_s.gsub("<textarea>", "").gsub("undefined</textarea>", "").gsub("</textarea>", "")

    parsed_json = JSON.parse(response)

    parsed_json.each do |location|
      puts location
      puts "\n\n"
    end

  end

end
