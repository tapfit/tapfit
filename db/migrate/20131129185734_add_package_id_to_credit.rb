class AddPackageIdToCredit < ActiveRecord::Migration
  def change
    add_column :credits, :package_id, :integer

    add_index :credits, :package_id
  end
end
