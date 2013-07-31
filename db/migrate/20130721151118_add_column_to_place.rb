class AddColumnToPlace < ActiveRecord::Migration
  def change
    add_column :places, :schedule_url, :string
  end
end
