

ActiveAdmin.register PromoCode do

  index do
    column :code
    column :amount
    column :quantity
    column :user_id, :type => :integer
    column :random_promo
    column :codes_used

    default_actions
  end

  controller do
   
    def scoped_collection
      PromoCode.where(:type => nil)
    end

    def permitted_params
      params.permit!
    end
  end

end
