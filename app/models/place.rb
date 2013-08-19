class Place < ActiveRecord::Base
  
  # Definitions
  acts_as_taggable_on :categories
  before_save :normalize_tags
  belongs_to :address
  has_many :workouts
  has_many :ratings
  has_many :photos, as: :imageable
  has_many :instructors, :through => :workouts
  self.per_page = 25

  # Methods
  def icon_photo
    photo = Photo.where(:id => self.icon_photo_id).first
    return "#{Photo.image_base_url}/images/icon/#{photo.id}.jpg" if !photo.nil?
  end

  def cover_photo
    photo = Photo.where(:id => self.cover_photo_id).first
    return "#{Photo.image_base_url}/images/large/#{photo.id}.jpg" if !photo.nil?
  end

  def todays_workouts
    Time.zone = self.address.timezone
    start_of_day = Time.now.beginning_of_day
    end_of_day = start_of_day + 48.hours

    Time.zone = "UTC"

    self.workouts.where("start_time BETWEEN ? AND ?", start_of_day, end_of_day)
  end

  def self.get_nearby_places(lat, lon, radius, search)
    if lat.nil? || lon.nil?
      lat = 39.110918
      lon = -84.515521
    end
    if radius.nil?
      radius = 0.5
    else
      radius = radius.to_f / 69
    end
    
    if search.nil?
      return Place.nearby(lat.to_f, lon.to_f, radius, nil) 
    else
      ids = Place.tagged_with([search], :any => true, :wild => true).pluck(:id)
      if ids.length == 0
        ids = Place.where("lower(name) LIKE ? OR lower(category) LIKE ?", "%#{search}%", "%#{search}%").pluck(:id)
      else
        ids = Place.where("lower(name) LIKE ? OR lower(category) LIKE ? OR id IN (?)", "%#{search}%", "%#{search}%", ids.join(",")).pluck(:id)
      end
      return Place.nearby(lat.to_f, lon.to_f, radius, ids)
    end
  end


  scope :nearby, lambda { |lat, lon, radius, ids|
    if ids.nil?
      return find_by_sql("SELECT places.*, 
                    3956 * 2 * asin( sqrt ( pow ( sin (( #{lat} - lat) * pi() / 180 / 2), 2) + cos (#{lat} * pi() / 180 ) * cos ( lat * pi() / 180 ) * pow ( sin (( #{lon} - lon ) * pi() / 180 / 2 ), 2) ) ) as distance FROM places INNER JOIN addresses ON places.address_id = addresses.id WHERE can_buy = true AND lat BETWEEN #{lat - radius} AND #{lat + radius} AND lon BETWEEN #{lon - radius} AND #{lon + radius} ORDER BY distance") 
    elsif ids.length == 0
      return []
    else
      return find_by_sql("SELECT places.*, 
                    3956 * 2 * asin( sqrt ( pow ( sin (( #{lat} - lat) * pi() / 180 / 2), 2) + cos (#{lat} * pi() / 180 ) * cos ( lat * pi() / 180 ) * pow ( sin (( #{lon} - lon ) * pi() / 180 / 2 ), 2) ) ) as distance FROM places INNER JOIN addresses ON places.address_id = addresses.id WHERE places.id IN (#{ids.join(", ")}) AND can_buy = true AND lat BETWEEN #{lat - radius} AND #{lat + radius} AND lon BETWEEN #{lon - radius} AND #{lon + radius} ORDER BY distance") 

    end
  }

  def as_json(options={})
    if !options[:list].nil?
      except_array ||= [ :crawler_source, :url, :icon_photo_id, :cover_photo_id, :source, :source_key, :tapfit_description, :source_description, :is_public, :can_dropin, :dropin_price, :created_at, :updated_at, :address_id ]
      options[:include] ||= [ :address, :categories ]
      options[:methods] ||= [ :class_times, :cover_photo, :icon_photo ]
    elsif !options[:detail].nil?    
      except_array ||= [ :crawler_source, :icon_photo_id, :cover_photo_id, :source, :source_key, :tapfit_description, :source_description, :is_public, :created_at, :updated_at, :address_id ]
      options[:include] ||= [ :address, :categories ]
      options[:methods] ||= [ :class_times, :cover_photo, :icon_photo, :reviews, :avg_rating ]
    end

    options[:except] ||= except_array
    super(options)

  end

  def class_times    
    
    Time.zone = self.address.timezone
    now = Time.now
    end_of_day = Time.now.beginning_of_day + 24.hours

    workouts = self.workouts.where("start_time BETWEEN ? AND ?", now, end_of_day).order("start_time ASC")
    
    Time.zone = "UTC"
    return workouts.pluck(:start_time)
  end

  def avg_rating
    return (self.ratings.count > 0) ? self.ratings.average(:rating) : -1
  end

  def reviews
    return self.ratings.where.not(:review => nil).order("created_at DESC").limit(5).as_json(:list => true)
  end

  def self.combine_place(address, attrs, tags)
    place = Place.where(:address_id => address.id).first
    if !place.nil?
      if place.name != attrs[:name]
        name = place.name.split(" ") & attrs["name"].split(" ")
        name = name.join(" ")
        place.name = name if name.strip != ""
      end
      place.category_list = place.category_list | tags if !tags.nil?
      place.save
    end
    return place
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
