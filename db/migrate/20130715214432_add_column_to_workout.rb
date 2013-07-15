class AddColumnToWorkout < ActiveRecord::Migration
  def change
    add_column :workouts, :active, :boolean, default: true

    add_index :workouts, :active
  end
end
