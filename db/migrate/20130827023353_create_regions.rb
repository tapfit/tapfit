class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.string :name
      t.string :city
      t.string :state
      t.float :lat
      t.float :lon
      t.integer :radius

      t.timestamps
    end
  end
end
