class AddTypeColumnToPlace < ActiveRecord::Migration
  def change
    add_column :places, :facility_type, :integer
  end
end
