class AddCrawlerInfoToWorkout < ActiveRecord::Migration

  disable_ddl_transaction!

  def change
    add_column :workouts, :crawler_info, :hstore

    add_index :workouts, :crawler_info, algorithm: :concurrently
  end
end
