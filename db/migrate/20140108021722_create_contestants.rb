class CreateContestants < ActiveRecord::Migration
  def change
    create_table :contestants do |t|
      t.string :email
      t.boolean :has_downloaded
      t.boolean :has_shared
      t.string :index
      t.string :show
      t.string :new

      t.timestamps
    end
  end
end
