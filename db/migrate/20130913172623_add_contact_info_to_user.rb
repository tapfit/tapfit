class AddContactInfoToUser < ActiveRecord::Migration
  def change
    add_column :users, :title, :string
    add_column :users, :phone, :string
    add_column :users, :company_id, :integer

    add_index :users, :company_id
  end
end
