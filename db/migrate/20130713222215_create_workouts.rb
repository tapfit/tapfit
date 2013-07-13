class CreateWorkouts < ActiveRecord::Migration
  def change
    create_table :workouts do |t|
      t.string :name
      t.timestamp :start_time
      t.timestamp :end_time
      t.integer :instructor_id
      t.integer :place_id
      t.text :source_description
      t.binary :workout_key
      t.string :source
      t.boolean :is_bookable, default: true
      t.float :price

      t.timestamps
    end

    add_index :workouts, :instructor_id
    add_index :workouts, :place_id
    add_index :workouts, :workout_key
    add_index :workouts, :source
    add_index :workouts, :is_bookable
    add_index :workouts, :start_time
    add_index :workouts, :end_time
  end
end
