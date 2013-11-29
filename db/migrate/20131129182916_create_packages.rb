class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :description
      t.integer :amount
      t.integer :fit_coins
      t.float :discount

      t.timestamps
    end
  end
end
