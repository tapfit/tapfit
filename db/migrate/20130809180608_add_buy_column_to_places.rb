class AddBuyColumnToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :can_buy, :boolean
  end
end
