require './lib/facility_type'

class Place < ActiveRecord::Base
  
  # Definitions
  acts_as_ordered_taggable_on :categories
  before_create :normalize_tags
  belongs_to :address
  has_many :workouts
  has_many :ratings
  has_many :photos, as: :imageable
  has_many :instructors, :through => :workouts
  has_many :receipts
  has_one :place_contract
  has_many :pass_details
  has_many :place_hours

  has_many :current_workouts, -> {
    self.select_values = 
      ["workouts.*"]
      where('workouts.start_time > ?', DateTime.now)
  }, class_name: "Workout"

  accepts_nested_attributes_for :place_hours
  accepts_nested_attributes_for :place_contract
  self.per_page = 30

  # Methods
  def icon_photo
    # photo = Photo.where(:id => self.icon_photo_id).first
    return "#{Photo.image_base_url}/images/icon/#{icon_photo_id}.jpg" if !icon_photo_id.nil?
  end

  def cover_photo
    # photo = Photo.where(:id => self.cover_photo_id).first
    return "#{Photo.image_base_url}/images/large/#{cover_photo_id}.jpg" if !cover_photo_id.nil?
  end

  def todays_workouts
    self.next_workouts
  end

  def next_workouts
    Time.zone = self.address.timezone
    start_of_day = Time.now.beginning_of_day
    end_of_day = start_of_day + 48.hours

    Time.zone = "UTC"

    self.workouts.where("start_time BETWEEN ? AND ?", start_of_day, end_of_day).where("price IS NOT NULL").where(:is_cancelled => false)
  end

  def next_workouts_json
    return self.current_workouts.as_json(:lean_list => true)
  end

  def self.get_nearby_places(lat, lon, radius, search)
    if lat.nil? || lon.nil?
      lat = 39.110918
      lon = -84.515521
    end
    if radius.nil?
      radius = 0.08
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
                    3956 * 2 * asin( sqrt ( pow ( sin (( #{lat} - lat) * pi() / 180 / 2), 2) + cos (#{lat} * pi() / 180 ) * cos ( lat * pi() / 180 ) * pow ( sin (( #{lon} - lon ) * pi() / 180 / 2 ), 2) ) ) as distance FROM places INNER JOIN addresses ON places.address_id = addresses.id WHERE lat BETWEEN #{lat - radius} AND #{lat + radius} AND show_place = TRUE AND can_buy = TRUE AND lon BETWEEN #{lon - radius} AND #{lon + radius} ORDER BY distance LIMIT 30") 
    elsif ids.length == 0
      return []
    else
      return find_by_sql("SELECT places.*, 
                    3956 * 2 * asin( sqrt ( pow ( sin (( #{lat} - lat) * pi() / 180 / 2), 2) + cos (#{lat} * pi() / 180 ) * cos ( lat * pi() / 180 ) * pow ( sin (( #{lon} - lon ) * pi() / 180 / 2 ), 2) ) ) as distance FROM places INNER JOIN addresses ON places.address_id = addresses.id WHERE places.id IN (#{ids.join(", ")}) AND lat BETWEEN #{lat - radius} AND #{lat + radius} AND show_place = TRUE AND can_buy = TRUE AND lon BETWEEN #{lon - radius} AND #{lon + radius} ORDER BY distance LIMIT 30") 

    end
  }

  def self.get_close_places(lat, lon, radius)
    if lat.nil? || lon.nil?
      lat = 39.110918
      lon = -84.515521
    end
    if radius.nil?
      radius = 0.08
    else
      radius = radius.to_f / 69
    end

    return Place.close(lat.to_f, lon.to_f, radius)

  end

  scope :close, lambda { |lat, lon, radius|
    joins(:address)
    .select("places.*, 3956 * 2 * asin( sqrt ( pow ( sin (( #{lat} - addresses.lat) * pi() / 180 / 2), 2) + cos (#{lat} * pi() / 180 ) * cos ( addresses.lat * pi() / 180 ) * pow ( sin (( #{lon} - addresses.lon ) * pi() / 180 / 2 ), 2) ) ) as distance")
    .order("distance")
    .where("addresses.lat BETWEEN ? AND ?", lat - radius, lat + radius)
    .where("addresses.lon BETWEEN ? AND ?", lon - radius, lon + radius)
    .where(:show_place => true)
    .where(:can_buy => true)
    .limit(30)
    .preload(:address, :current_workouts)
  }

  def passes_sold_today
    Time.zone = self.address.timezone
    starts = Time.now.beginning_of_day
    ends = starts + 24.hours
    Time.zone = "UTC"
    self.receipts.where("created_at BETWEEN ? AND ?", starts, ends).count
  end

  def as_json(options={})
    if !options[:list].nil?
      except_array ||= [ :crawler_source, :url, :icon_photo_id, :cover_photo_id, :source, :source_key, :tapfit_description, :is_public, :dropin_price, :updated_at, :address_id, :is_cancelled ]
      options[:include] ||= [ :address, :categories ]
      options[:methods] ||= [ :class_times, :cover_photo, :icon_photo, :avg_rating, :total_ratings, :category ]
    elsif !options[:detail].nil?    
      except_array ||= [ :crawler_source, :icon_photo_id, :cover_photo_id, :source, :source_key, :is_public, :updated_at, :address_id, :is_cancelled ]
      options[:include] ||= [ :address, :categories ]
      options[:methods] ||= [ :class_times, :cover_photo, :day_pass, :icon_photo, :reviews, :avg_rating, :total_ratings, :category ]
    elsif !options[:search].nil?
      options[:only] ||= [ :id ]      
      options[:include] ||= [ :address ]
      options[:methods] ||= [ :display_name ]
    elsif !options[:lean_list].nil?
      except_array ||= [ :crawler_source, :url, :icon_photo_id, :cover_photo_id, :source, :source_key, :tapfit_description, :is_public, :dropin_price, :updated_at, :address_id, :is_cancelled, :phone_number, :source_description, :created_at, :schedule_url, :can_buy, :facility_type, :lowest_price, :lowest_original_price, :show_place, :distance ]
      options[:include] ||= [ :address ]
      options[:methods] ||= [ :cover_photo, :next_workouts_json ]
    end

    options[:except] ||= except_array
    super(options)

  end

  def current_workouts_json
    self.current_workouts.as_json(:lean_list => true)
  end

  def display_name
    return "#{self.name} - #{self.address.city}"
  end

  def day_pass
    if self.facility_type == FacilityType::DayPassWithClass || self.facility_type == FacilityType::DayPassNoClass
      return self.next_workouts.where(:is_day_pass => true)
    else
      return nil
    end
  end

  def category
    category = self.category_list[0]
    if category.nil?
      return ""
    else
      return category
    end
  end

  def pass_detail_info
    pass_detail = self.pass_details.first
    if pass_detail.nil?
      return nil
    else
      return self.pass_details.first.pass_type
    end
  end

  def class_times    
    return next_workouts.where(:is_day_pass => false).pluck(:start_time)
  end

  def avg_rating
    return (self.ratings.count > 0) ? self.ratings.average(:rating).to_f : -1
  end

  def num_of_reviews
    return self.ratings.count
  end

  def reviews
    return self.ratings.where.not(:review => nil).order("created_at DESC").limit(5).as_json(:list => true)
  end

  def total_ratings
    return self.ratings.count
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
