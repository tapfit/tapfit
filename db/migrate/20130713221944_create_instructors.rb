class CreateInstructors < ActiveRecord::Migration
  def change
    create_table :instructors do |t|
      t.string :first_name
      t.string :last_name
      t.string :email, :unique => true
      t.string :photo_url
      t.string :phone_number

      t.timestamps
    end

    add_index :instructors, :email, :unique => true
    add_index :instructors, :phone_number, :unique => true
  end
end
