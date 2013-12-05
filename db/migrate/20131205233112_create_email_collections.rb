class CreateEmailCollections < ActiveRecord::Migration
  def change
    create_table :email_collections do |t|
      t.string :email
      t.string :city

      t.timestamps
    end
  end
end
