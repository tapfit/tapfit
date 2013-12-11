class AddMbEmailToUser < ActiveRecord::Migration
  def change
    add_column :users, :mb_email, :text
  end
end
