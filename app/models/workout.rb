class Workout < ActiveRecord::Base
  
  belongs_to :instructor
  belongs_to :place
  has_one :address, :through => :place

  def as_json(options={})
    if !options[:place].nil?
      except_array ||= [ :instructor_id, :place_id, :source_description, :workout_key, :source, :price, :created_at, :updated_at ]
      options[:include] ||= [ :instructor ]
    elsif !options[:detail].nil?      
      except_array ||= [ :created_at, :updated_at, :workout_key, :source ]
      options[:include] ||= [ :instructor ]
    end
    options[:except] ||= except_array
    super(options)
  end
end
