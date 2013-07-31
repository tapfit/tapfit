class AddColumnToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :timezone, :string
  end
end
