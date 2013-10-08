class AddRandomColumnToPromoCode < ActiveRecord::Migration
  def change
    add_column :promo_codes, :random_promo, :float
  end
end
