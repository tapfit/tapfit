require './lib/resque_job'
require 'rest-client'

class GoRecessLoc < ResqueJob

  def self.perform(page, rerun, lat, lon)

    if rerun.nil? || rerun
      GoRecessLoc.get_lat_lon.each do |latlon|
        Resque.enqueue(GoRecessLoc, 1, false, latlon.lat, latlon.lon)
      end
    else
      GoRecessLoc.get_locations(page, lat, lon)   
    end
    
  end
  
  def self.get_lat_lon
    lat_lon_arr = []
    lat_lon_arr << LatLon.new(39.136111100000001, -84.503055599999996)
    return lat_lon_arr
  end

  def self.get_locations(page, lat, lon)
    response = RestClient.post 'https://www.gorecess.com/search', 
      {
        :search => 
        { 
          :category_ids => [1, 2, 3, 4, 5, 9, 11, 14], 
          :radius => "25", 
          :type => "providers", 
          :page => page, 
          :latitude => lat,  
          :longitude => lon 
        } 
      }

    parsed_json = JSON.parse(response.to_str)

    parsed_json["providers"].each do |provider|
      puts provider["name"]
    end

    if page < parsed_json["pagination"]["total_pages"]
      page += 1
      puts "enqueing GoRecessLoc in get_locations"
      Resque.enqueue(GoRecessLoc, page, false, lat, lon)
    end
  end

end
