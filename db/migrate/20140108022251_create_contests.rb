class CreateContests < ActiveRecord::Migration
  def change
    create_table :contests do |t|
      t.string :name
      t.string :url
      t.string :body
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :is_live

      t.timestamps
    end
  end
end
