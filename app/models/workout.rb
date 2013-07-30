class Workout < ActiveRecord::Base
  
  default_scope { where("start_time BETWEEN ? AND ?", 
                        (Time.now).beginning_of_day, 
                        ((Time.now).beginning_of_day + 24.hours))
                  .order("start_time DESC") }

  belongs_to :instructor
  belongs_to :place

  has_one :timezone, :through => :place, :through => :address

  def as_json(options={})
    if !options[:place].nil?
      except_array ||= [ :instructor_id, :place_id, :source_description, :workout_key, :source, :price, :created_at, :updated_at ]
    elsif !options[:detail].nil?      
      except_array ||= [ :created_at, :updated_at, :workout_key, :source ]
      options[:include] ||= [ :instructor ]
    end
    options[:except] ||= except_array
    super(options)
  end
end
