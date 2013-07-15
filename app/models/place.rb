class Place < ActiveRecord::Base
  acts_as_taggable_on :categories
  belongs_to :address

  def self.get_nearby_places(lat, lon)
    return Place.nearby(lat, lon, 0.05)  
  end

  scope :nearby, lambda { |lat, lon, radius|
      joins(:address).
      where("lat BETWEEN ? AND ?", lat - radius, lat + radius).
      where("lon BETWEEN ? AND ?", lon - radius, lon + radius)
  }

end
