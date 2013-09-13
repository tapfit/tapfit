class ChangeColumnNameForCredits < ActiveRecord::Migration
  def change
    rename_column :credits, :promo_id, :promo_code_id
  end
end
