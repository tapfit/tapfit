class AddHasBookedColumnToReceipts < ActiveRecord::Migration
  def change
    add_column :receipts, :has_booked, :boolean
  end
end
