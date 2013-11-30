

ActiveAdmin.register PromoCode do

  index do
    column :code
    column :amount
    column :quantity
    column :user_id
    column :company_id
    column :random_promo
    column :codes_used

    default_actions
  end

end
