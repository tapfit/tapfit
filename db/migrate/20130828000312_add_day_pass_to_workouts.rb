class AddDayPassToWorkouts < ActiveRecord::Migration
  def change
    add_column :workouts, :is_day_pass, :boolean, :default => false

    add_index :workouts, :is_day_pass
  end
end
