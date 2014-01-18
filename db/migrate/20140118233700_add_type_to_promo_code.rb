class AddTypeToPromoCode < ActiveRecord::Migration
  def change
    add_column :promo_codes, :type, :string

    add_index :promo_codes, :type
  end
end
