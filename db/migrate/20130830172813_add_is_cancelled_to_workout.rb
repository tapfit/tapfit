class AddIsCancelledToWorkout < ActiveRecord::Migration
  def change
    add_column :workouts, :is_cancelled, :boolean, :default => false

    add_index :workouts, :is_cancelled
  end
end
