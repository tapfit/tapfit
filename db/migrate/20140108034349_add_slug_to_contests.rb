class AddSlugToContests < ActiveRecord::Migration
  def change
    add_column :contests, :slug, :string
    add_index :contests, :slug
  end
end
