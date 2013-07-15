class Workout < ActiveRecord::Base

  def as_json(options={})
    if !options[:place].nil?
      except_array ||= [ :instructor_id, :place_id, :source_description, :workout_key, :source, :price, :created_at, :updated_at ]
    elsif !options[:detail].nil?      
      except_array ||= [ :created_at, :updated_at, :latitude, :longitude, :physical_address_id, :billing_address_id ]
      options[:include] ||= [ :physical_address, :billing_address, :business_hours, :amenities ]
      options[:methods] ||= [ :avg_rating ]
    end
    options[:except] ||= except_array
    super(options)

  end
end
