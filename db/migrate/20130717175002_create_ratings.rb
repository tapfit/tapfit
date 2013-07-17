class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :rating, null: false
      t.integer :user_id, null: false
      t.binary :workout_key
      t.integer :workout_id
      t.integer :place_id, null: false
      t.text :review

      t.timestamps
    end

    add_index :ratings, :rating
    add_index :ratings, :user_id
    add_index :ratings, :place_id
    add_index :ratings, :workout_id
    add_index :ratings, :workout_key
  end
end
