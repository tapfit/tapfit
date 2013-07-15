class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :url
      t.integer :user_id
      t.binary :workout_key
      t.integer :place_id

      t.timestamps
    end

    add_index :photos, :user_id
    add_index :photos, :workout_key
    add_index :photos, :place_id
  end
end
