class AddIndexToAddressIdToPlace < ActiveRecord::Migration
  disable_ddl_transaction!

  def change
    add_index :places, :address_id, algorithm: :concurrently
  end
end
