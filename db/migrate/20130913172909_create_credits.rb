class CreateCredits < ActiveRecord::Migration
  def change
    create_table :credits do |t|
      t.float :total
      t.float :remaining
      t.timestamp :expiration_date
      t.integer :user_id
      t.integer :promo_id

      t.timestamps
    end

    add_index :credits, :user_id
    add_index :credits, :promo_id
  end
end
