class Place < ActiveRecord::Base
  acts_as_taggable_on :categories
  before_save :normalize_tags
  belongs_to :address
  has_many :workouts

  self.per_page = 5
  
  def set_icon_photo(url, user)
    photo = Photo.where(:url => url).first
    if photo.nil?
      if !user.nil?
        user_id = user.id
      end
      photo = Photo.create(:url => url, :place_id => self.id, :user_id => user_id)
    end
    self.icon_photo_id = photo.id
    self.save
  end

  def icon_photo
    return Photo.where(:id => self.icon_photo_id).first
  end

  def set_cover_photo(url, user)
    photo = Photo.where(:url => url).first
    if photo.nil?
      if !user.nil?
        user_id = user.id
      end
      photo = Photo.create(:url => url, :place_id => self.id, :user_id => user_id)
    end
    self.cover_photo_id = photo.id
    self.save
  end

  def cover_photo
    return Photo.where(:id => self.cover_photo_id).first
  end

  def self.get_nearby_places(lat, lon)
    return Place.nearby(lat.to_f, lon.to_f, 0.05)  
  end

  def next_class
    workout = Workout.where(:place_id => self.id).order("start_time DESC")
    if workout.nil?
      return nil
    else
      workout.first.as_json(:place => true)
    end
  end

  scope :nearby, lambda { |lat, lon, radius|
      joins(:address).
      where("lat BETWEEN ? AND ?", lat - radius, lat + radius).
      where("lon BETWEEN ? AND ?", lon - radius, lon + radius)
  }

  def as_json(options={})
    if !options[:list].nil?
      except_array ||= [ :url, :icon_photo_id, :cover_photo_id, :category, :phone_number, :source, :source_key, :tapfit_description, :source_description, :is_public, :can_dropin, :dropin_price, :created_at, :updated_at, :address_id ]
      options[:include] ||= [ :address, :categories ]
      options[:methods] ||= [ :next_class, :get_cover_photo, :get_icon_photo ]
    elsif !options[:detail].nil?      
      except_array ||= [ :created_at, :updated_at, :latitude, :longitude, :physical_address_id, :billing_address_id ]
      options[:include] ||= [ :physical_address, :billing_address, :business_hours, :amenities ]
      options[:methods] ||= [ :avg_rating ]
    end
    options[:except] ||= except_array
    super(options)

  end

private

  def normalize_tags
    size = self.category_list.length
    i = 0
    while i < size do
      category = self.category_list[i]
      category = category.gsub("_", " ")
      category = category.split(' ').map(&:capitalize).join(' ')
      self.category_list[i] = category
      i = i + 1
    end 
  end
end
