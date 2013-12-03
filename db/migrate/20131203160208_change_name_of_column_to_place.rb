class ChangeNameOfColumnToPlace < ActiveRecord::Migration

  disable_ddl_transaction!

  def change
    
    remove_column :places, :can_dropin

    add_column :places, :show_place, :boolean

    add_index :places, :show_place, algorithm: :concurrently

  end
end
