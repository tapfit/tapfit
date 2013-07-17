class Place < ActiveRecord::Base
  acts_as_taggable_on :categories
  before_save :normalize_tags
  belongs_to :address
  has_many :workouts
  has_many :ratings
  has_many :photos, as: :imageable

  def get_workouts
    self.workouts.where("start_time > ?", Time.now).order("start_time DESC")
  end

  self.per_page = 25
  
  def set_icon_photo(url, user)
    self.icon_photo_id = create_photo(url, user).id
    self.save
  end

  def icon_photo
    return Photo.where(:id => self.icon_photo_id).first
  end

  def set_cover_photo(url, user)
    self.cover_photo_id = create_photo(url, user).id
    self.save
  end

  def cover_photo
    return Photo.where(:id => self.cover_photo_id).first
  end

  def self.get_nearby_places(lat, lon)
    if lat.nil? || lon.nil?
      lat = 39.110918
      lon = -84.515521
    end
    return Place.nearby(lat.to_f, lon.to_f, 0.5)  
  end

  def next_class
    workout = Workout.where(:place_id => self.id).order("start_time DESC")
    if workout.nil?
      return []
    else
      workout.first.as_json(:place => true).to_a
    end
  end

  def avg_rating
    return (self.ratings.count > 0) ? self.ratings.average(:rating) : -1
  end

  def reviews
    return self.ratings.where.not(:review => nil).order("created_at DESC").limit(5)
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
      options[:methods] ||= [ :next_class, :cover_photo, :icon_photo ]
    elsif !options[:detail].nil?    
      except_array ||= [ :icon_photo_id, :cover_photo_id, :category, :source, :source_key, :tapfit_description, :source_description, :is_public, :created_at, :updated_at, :address_id ]
      options[:include] ||= [ :address, :categories ]
      options[:methods] ||= [ :next_class, :cover_photo, :icon_photo, :reviews, :avg_rating ]
    end

    options[:except] ||= except_array
    super(options)

  end

  def create_photo(url, user)
    photo = Photo.where(:url => url).first
    if photo.nil?
      if !user.nil?
        user_id = user.id
      end
      photo = Photo.create(:url => url, :place_id => self.id, :user_id => user_id)
    end
    return photo
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
