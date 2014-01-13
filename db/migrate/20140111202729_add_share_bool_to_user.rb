class AddShareBoolToUser < ActiveRecord::Migration
  def change
    add_column :users, :shared, :integer, default: 0
  end
end
