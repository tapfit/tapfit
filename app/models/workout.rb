class Workout < ActiveRecord::Base
  
  default_scope { where("start_time BETWEEN ? AND ?", Time.zone.now.beginning_of_day, Time.zone.now.beginning_of_day + 1.days) }

  belongs_to :instructor
  belongs_to :place

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
