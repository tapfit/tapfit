class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :name, null: false
      t.integer :address_id
      t.string :source, index:true
      t.binary :source_key, index:true
      t.string :url
      t.string :category, index: true
      t.string :phone_number
      t.text :tapfit_description
      t.text :source_description
      t.boolean :is_public, index:true, null: false, default: true
      t.boolean :can_dropin, index:true, null: false, default: true
      t.float :dropin_price

      t.timestamps
    end

    add_index :places, :source
    add_index :places, :source_key
    add_index :places, :category
    add_index :places, :is_public
    add_index :places, :can_dropin

  end
end
