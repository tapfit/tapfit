class AddLowestPriceToPlace < ActiveRecord::Migration
  def change
    add_column :places, :lowest_price, :float
  end
end
