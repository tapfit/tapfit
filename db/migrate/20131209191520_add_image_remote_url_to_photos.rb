class AddImageRemoteUrlToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :image_remote_url, :string
    add_column :photos, :url, :string
  end
end
