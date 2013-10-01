class AddQuantityToPromoCode < ActiveRecord::Migration
  def change
    add_column :promo_codes, :quantity, :integer
  end
end
