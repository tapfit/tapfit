require './lib/resque_job'
require 'rest-client'

class GoRecessLoc < ResqueJob

  def self.perform(page, rerun, lat, lon)
    Rails.logger = Logger.new("resque")

    if rerun.nil? || rerun
      GoRecessLoc.get_lat_lon.each do |latlon|
        Rails.logger.info "enqueing GoRecessLoc"
        Resque.enqueue(GoRecessLoc, 1, false, latlon.lat, latlon.lon)
      end
    else
      Rails.logger.info "getting locations"
      GoRecessLoc.get_locations(page, lat, lon)   
    end
    
  end
  
  def self.get_lat_lon
    lat_lon_arr = []
    lat_lon_arr << LatLon.new(39.136111100000001, -84.503055599999996)
    lat_lon_arr << LatLon.new(41.850033000000003, -87.650052299999999)
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

    Rails.logger.info parsed_json["providers"]

    if page < parsed_json["pagination"]["total_pages"]
      page += 1
      Rails.logger.info "enqueing GoRecessLoc in get_locations"
      Resque.enqueue(GoRecessLoc, page, false, lat, lon)
    end
  end

  class LatLon
    attr_accessor :lat, :lon

    def initialize(lat, lon)
      @lat = lat
      @lon = lon
    end
  end
end
