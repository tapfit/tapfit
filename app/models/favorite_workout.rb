class FavoriteWorkout < Favorite

  belongs_to :workout

  validates :workout_id, :presence => true
  validates :workout_key, :presence => true

end
