class RemoveCategoryColumnFromPlace < ActiveRecord::Migration
  def change

    remove_column :places, :category
  end
end
