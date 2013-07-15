class AddPhotoUrlToPlace < ActiveRecord::Migration
  def change
    add_column :places, :icon_photo_id, :integer
    add_column :places, :cover_photo_id, :integer
  end
end
