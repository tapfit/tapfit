class CreateCheckins < ActiveRecord::Migration
  def change
    create_table :checkins do |t|
      t.integer :place_id, null: false
      t.integer :user_id, null: false
      t.float :lat
      t.float :lon

      t.timestamps
    end

    add_index :checkins, :place_id
    add_index :checkins, :user_id
  end
end
