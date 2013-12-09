class AddColumnsToRegion < ActiveRecord::Migration
  def change
    add_column :regions, :nwbound, :hstore
    add_column :regions, :swbound, :hstore
    add_column :regions, :nebound, :hstore
    add_column :regions, :sebound, :hstore
  end
end
