class CreatePassDetails < ActiveRecord::Migration
  def change
    create_table :pass_details do |t|
      t.integer :place_id
      t.text :fine_print
      t.text :instructions

      t.timestamps
    end

    add_index :pass_details, :place_id
  end
end
