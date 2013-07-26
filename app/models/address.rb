class Address < ActiveRecord::Base
  
  before_validation :get_lat_lon
  validates :lat, :presence => { :message => "lat needs to be present" }
  validates :lon, :presence => { :message => "lon needs to be present" }

  def address
    return "#{line1} #{line2}, #{city}, #{state} #{zip}"
  end

  def get_lat_lon
    if lat.nil? || lon.nil?
      coordinates = Geocoder.coordinates(address)
      if !coordinates.nil?
        self.lat = coordinates[0]
        self.lon = coordinates[1]
      end
    end
  end

  def as_json(options={})
    
    except_array ||= [ :created_at, :updated_at ]
    options[:except] ||= except_array
    super(options)

  end
end
