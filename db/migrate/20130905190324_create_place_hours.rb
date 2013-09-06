class CreatePlaceHours < ActiveRecord::Migration
  def change
    create_table :place_hours do |t|
      t.integer :day_of_week
      t.timestamp :open
      t.timestamp :close
      t.integer :place_id

      t.timestamps
    end

    add_index :place_hours, :place_id
  end
end
