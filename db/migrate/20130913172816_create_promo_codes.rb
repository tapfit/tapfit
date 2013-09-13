class CreatePromoCodes < ActiveRecord::Migration
  def change
    create_table :promo_codes do |t|
      t.integer :company_id
      t.string :code
      t.boolean :has_used
      t.float :amount

      t.timestamps
    end

    add_index :promo_codes, :company_id
    add_index :promo_codes, :has_used
  end
end
