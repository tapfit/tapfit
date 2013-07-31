ActiveAdmin.register Place do

  index do
    column :name
    column :schedule_url
    column :url
    column :source
    column :dropin_price
    column :is_public
    column :icon_photo
    column :cover_photo
    column "City" do |i|
      i.address.city
    end
    column "State" do |i|
      i.address.state
    end

    default_actions 
  end

  action_item :only => :show do 
    link_to('Add a Photo', new_place_photo_path(place))
  end


  filter :name, :label => "Name"
  filter :address_city, :label => "City", :as => :string

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

