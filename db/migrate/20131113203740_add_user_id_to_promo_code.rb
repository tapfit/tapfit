class AddUserIdToPromoCode < ActiveRecord::Migration
  def change
    add_column :promo_codes, :user_id, :integer

    add_index :promo_codes, :user_id
  end
end
