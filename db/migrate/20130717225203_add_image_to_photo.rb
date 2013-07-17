class AddImageToPhoto < ActiveRecord::Migration
  def change
    add_attachment :photos, :image
    remove_column :photos, :url
  end
end
