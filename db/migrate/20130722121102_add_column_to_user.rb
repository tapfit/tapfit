class AddColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :type, :string
      
    add_index :users, :type
=begin
    User.create! do |r|
      r.email = 'admin@example.com'
      r.password = 'password'
      r.type = 'AdminUser'
    end
=end
  end
end
