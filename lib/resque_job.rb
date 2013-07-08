class ResqueJob

  def self.queue; :crawler; end

  class LatLon
    attr_accessor :lat, :lon

    def initialize(lat, lon)
      @lat = lat
      @lon = lon
    end
  end


end

