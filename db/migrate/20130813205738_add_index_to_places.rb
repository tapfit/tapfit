class AddIndexToPlaces < ActiveRecord::Migration
  def change
    add_index :places, :can_buy
  end
end
