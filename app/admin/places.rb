ActiveAdmin.register Place do

  index do
    column :name
    column :schedule_url
    column :url
    column :source
    column :dropin_price
    column :can_buy
    column :icon_photo
    column :cover_photo
    column :category
    column :crawler_source
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
  filter :source

  form do |f|
    f.inputs "Place Details" do
      f.input :name
      f.input :url
      f.input :schedule_url
      f.input :phone_number
      f.input :source_description
      f.input :source
      f.input :crawler_source
      f.input :dropin_price
      f.input :can_buy
      f.input :category
    end

    f.inputs "Contract", :for => [ :place_contract, f.object.place_contract || PlaceContract.new ] do  |contract|
      contract.input :price
      contract.input :quantity
      contract.input :discount
    end 
    
    f.actions
  end


  controller do
    def new
        redirect_to new_place_path
    end

    def update
      place_params = permitted_params[:place]
      contract_params = place_params[:place_contract_attributes]
      contract_params[:place_id] = permitted_params[:id]
      place_params = place_params.except!(:place_contract_attributes)
      place = Place.find(permitted_params[:id])
      place.update_attributes!(place_params)

      puts contract_params
      
      if (!contract_params[:price].empty? || !contract_params[:discount].empty?) && !contract_params[:quantity]
        if !place.place_contract.nil?
          place.place_contract.destroy
        end  
        contract = PlaceContract.create(contract_params)
        place.workouts.where("start_time > ?", Time.now).update_all(:price => contract.price)
      end

      redirect_to admin_place_path(place)

    end

    def permitted_params
      params.permit!
    end
  end
end

