require 'resque'
require './lib/resque_job'

class SetPhotos < ResqueJob

  @queue = :add_photos

  def self.perform(place_id = nil)

    if place_id.nil?
      
      Place.where(:can_buy => true).each do |place|
        if place.cover_photo.nil?

        end
      end

    else

    end
  end

  def self.set_photo(place)
    
    if category == Category::Yoga
      
    end 

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
