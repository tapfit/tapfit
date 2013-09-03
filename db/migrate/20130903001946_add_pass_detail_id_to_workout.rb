class AddPassDetailIdToWorkout < ActiveRecord::Migration
  def change
    add_column :workouts, :pass_detail_id, :integer

    add_index :workouts, :pass_detail_id
  end
end
