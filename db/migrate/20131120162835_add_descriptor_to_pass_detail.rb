class AddDescriptorToPassDetail < ActiveRecord::Migration
  def change
    add_column :pass_details, :pass_type, :integer

    add_index :pass_details, :pass_type
  end
end
