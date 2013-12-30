class AddIndexToTrackings < ActiveRecord::Migration
  def change
    add_index :trackings, :user_id
    add_index :trackings, :hexicode
  end
end
