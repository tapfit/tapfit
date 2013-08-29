class AddOriginalPriceToWorkout < ActiveRecord::Migration
  def self.up
    add_column :workouts, :original_price, :float

    Workout.connection.execute("update workouts set original_price = price")
  end

  def self.down

    remove_column :workouts, :original_price
  end
end
