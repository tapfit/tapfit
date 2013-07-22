ActiveAdmin.register Place do

  index do
    column :name
    column :schedule_url
    column :url
    column :source
    column :dropin_price
    column :is_public
    default_actions 
  end

  filter :source

  form do |f|
    f.inputs "Place Details" do
      f.input :name
      f.input :url
      f.input :schedule_url
      f.input :phone_number
      f.input :source_description
      f.input :source
      f.input :dropin_price
    end
    f.actions
  end


  controller do
    def permitted_params
      params.permit!
    end
  end
end

