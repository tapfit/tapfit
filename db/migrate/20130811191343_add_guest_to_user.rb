class AddGuestToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_guest, :boolean, :default => false

    add_index :users, :is_guest
  end
end
