class AddColumnsToRegion < ActiveRecord::Migration
  def change
    add_column :regions, :low_lat, :float
    add_column :regions, :high_lat, :float
    add_column :regions, :low_lon, :float
    add_column :regions, :high_lon, :float
  end
end
