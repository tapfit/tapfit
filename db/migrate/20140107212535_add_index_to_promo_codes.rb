class AddIndexToPromoCodes < ActiveRecord::Migration
  disable_ddl_transaction!
  
  def change
    add_index :promo_codes, :code, algorithm: :concurrently
  end
end
