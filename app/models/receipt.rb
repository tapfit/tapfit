class Receipt < ActiveRecord::Base

  belongs_to :user
  belongs_to :place
  belongs_to :workout

  def place_json
    self.place.as_json(:detail => true)
  end

  def workout_json
    self.workout.as_json(:detail => true)
  end
  

  def as_json(options={})
    options[:except] ||= [:place_id, :user_id, :workout_id, :workout_key, :updated_at]
    options[:methods] ||= [ :workout_json, :place_json ]
    super(options)
  end 

end
