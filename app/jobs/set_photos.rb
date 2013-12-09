require 'resque'
require './lib/resque_job'
require './lib/category'

class SetPhotos < ResqueJob

  @queue = :add_photos

  def self.perform(place_id = nil)

    if place_id.nil?
      Place.where(:can_buy => true).each do |place|
        if place.cover_photo.nil?
          SetPhotos.set_photo(place)
        end
      end
    else
      place = Place.where(:id => place_id).first
      SetPhotos.set_photo(place) if !place.nil?
    end
  end

  def self.set_photo(place)
    
    category = 'gym'
    if place.category == Category::Yoga
      category = 'yoga'
    elsif place.category == Category::Gym
      category = 'gym'
    elsif place.category == Category::PilatesBarre
      category = 'pilates-barre'
    elsif place.category == Category::Cardio
      category = 'cardio'
    elsif place.category == Category::Dance
      category = 'dance'
    elsif place.category == Category::Strength
      category = 'strength'
    elsif place.category == Category::MartialArts || place.category == Category::Boxing
      category = 'boxing'
    end

    url = SetPhotos.choose_a_photo(category)
    
    photo = Photo.create(:place_id => place.id, :url => url)

    place.photos << photo
    place.icon_photo_id = photo.id
    place.cover_photo_id = photo.id
    place.save
  end

  def self.choose_a_photo(category)
    
    s3 = AWS::S3.new
    bucket = s3.buckets['basic-photos']
    photo_count = bucket.objects.with_prefix("#{category}/").count - 1
    chosen_photo = (0..photo_count).to_a.sort{ rand() - 0.5 }[0]
    url = "https://s3-us-west-2.amazonaws.com/basic-photos/#{category}/#{chosen_photo}.jpg"
    return url

  end

end
