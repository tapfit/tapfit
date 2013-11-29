
ActiveAdmin.register Package do

  index do
    column :description
    column :amount
    column :fit_coins
    column :discount

    default_actions
  end
  
  form do |f|
    f.inputs "Fit Coin Package" do
      f.input :description
      f.input :amount
      f.input :fit_coins
      f.input :discount
    end

    f.actions
  end

  controller do
    def permitted_params
      params.permit!
    end
  end

  
end
