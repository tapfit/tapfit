class AddIndexToAddress < ActiveRecord::Migration
  def change
    add_index :addresses, :lat
    add_index :addresses, :lon
    add_index :addresses, :city
  end
end
