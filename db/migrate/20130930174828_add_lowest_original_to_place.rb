class AddLowestOriginalToPlace < ActiveRecord::Migration
  def change
    add_column :places, :lowest_original_price, :float
  end
end
