class ArchivedWorkout < Workout
  #set_table_name :workouts
  #default_scope { where(:active => false) }

  def self.default_scope
    where(:active => false)
  end
end
