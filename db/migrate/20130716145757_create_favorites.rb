class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.binary :workout_key
      t.integer :workout_id
      t.integer :user_id
      t.integer :place_id
      t.string :type

      t.timestamps
    end

    add_index :favorites, :workout_key
    add_index :favorites, :workout_id
    add_index :favorites, :user_id
    add_index :favorites, :place_id
  end
end
