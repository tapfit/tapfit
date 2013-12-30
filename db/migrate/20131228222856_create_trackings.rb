class CreateTrackings < ActiveRecord::Migration
  def change
    create_table :trackings do |t|
      t.string :distinct_id
      t.string :utm_medium
      t.string :utm_source
      t.string :utm_campaign
      t.string :utm_content
      t.boolean :download_iphone, :default => false
      t.boolean :download_android, :default => false
      t.string :hexicode
      t.string :region
      t.string :city

      t.timestamps
    end

    add_index :trackings, :distinct_id
    add_index :trackings, :hexicode
    add_index :trackings, :download_iphone
    add_index :trackings, :download_android
  end
end
