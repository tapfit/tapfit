module WorkoutKey

  def self.get_workout_key(id, name)
    return Digest::SHA1.hexdigest("#{id}#{name}") 
  end
end
