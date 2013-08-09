class AddColumnsToWorkout < ActiveRecord::Migration
  def change
    add_column :workouts, :can_buy, :boolean
  end
end
