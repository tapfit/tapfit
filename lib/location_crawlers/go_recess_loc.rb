require './lib/resque_job'
require 'rest-client'

class GoRecessLoc < ResqueJob

  def self.perform(page, rerun, lat, lon)
    if rerun.nil? || rerun
      get_lat_lon.each do |latlon|
        puts "enqueing GoRecessLoc"
        Resque.enqueue(GoRecessLoc, 1, false, latlon.lat, latlon.lon)
      end
    else
      puts "getting locations"
      get_locations(page, lat, lon)
    end
    
  end

private
  
  def get_lat_lon
    lat_lon_arr = []
    lat_lon_arr << LatLon.new(:lat => 39.136111100000001, :lon => -84.503055599999996)
    lat_lon_arr << LatLon.new(:lat => 41.850033000000003, :lon => -87.650052299999999)
    return lat_lon_arr
  end

  def get_locations(page, lat, lon)
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

    puts parsed_json["providers"]

    if page < parsed_json["pagination"]["total_pages"]
      page += 1
      puts "enqueing GoRecessLoc in get_locations"
      Resque.enqueue(GoRecessLoc, page, false, lat, lon)
    end
  end

  class LatLon
    attr_accessor :lat, :lon
  end
end
