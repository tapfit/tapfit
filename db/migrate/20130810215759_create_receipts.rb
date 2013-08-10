class CreateReceipts < ActiveRecord::Migration
  def change
    create_table :receipts do |t|
      t.integer :place_id
      t.integer :user_id
      t.integer :workout_id
      t.float :price
      t.binary :workout_key
      t.timestamp :expiration_date
      t.boolean :has_used, :default => false

      t.timestamps
    end

    add_index :receipts, :place_id
    add_index :receipts, :user_id
    add_index :receipts, :workout_id
    add_index :receipts, :workout_key
    add_index :receipts, :has_used
  end
end
