class Receipt < ActiveRecord::Base

  belongs_to :user
  belongs_to :place
  belongs_to :workout
  has_one :pass_detail, :through => :workout

  def place_json
    self.place.as_json(:detail => true)
  end

  def workout_json
    self.workout.as_json(:detail => true)
  end
  

  def as_json(options={})
    options[:except] ||= [:place_id, :user_id, :workout_id, :workout_key, :updated_at, :has_booked ]
    options[:methods] ||= [ :workout_json, :place_json ]
    options[:include] ||= [ :user ] 
    super(options)
  end 

end
