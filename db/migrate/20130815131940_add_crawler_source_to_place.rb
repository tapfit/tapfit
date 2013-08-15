class AddCrawlerSourceToPlace < ActiveRecord::Migration
  def change
    add_column :places, :crawler_source, :integer

    add_index :places, :crawler_source
  end
end
