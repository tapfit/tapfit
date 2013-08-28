class CreatePlaceContracts < ActiveRecord::Migration
  def change
    create_table :place_contracts do |t|
      t.integer :quantity
      t.float :price
      t.float :discount
      t.integer :place_id

      t.timestamps
    end

    add_index :place_contracts, :place_id
  end
end
