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
      f.input :facility_type
      f.input :category
      f.has_many :place_hours do |hour|
        hour.input :day_of_week
        hour.input :open
        hour.input :close
        hour.input :_destroy, :as=>:boolean, :required => false, :label => 'Delete Hour'
      end
    end

    f.inputs "Contract", :for => [ :place_contract, f.object.place_contract || PlaceContract.new ] do  |contract|
      contract.input :price
      contract.input :quantity
      contract.input :discount
      contract.input :_destroy, :as => :boolean, :required => false, :label => "Delete Contract"
    end 
    
    f.actions
  end


  controller do
    def new
        redirect_to new_place_path
    end

    def update

      puts permitted_params
      # return

      place_params = permitted_params[:place]
      contract_params = place_params[:place_contract_attributes]
      hour_params = place_params[:place_hours_attributes]
      contract_params[:place_id] = permitted_params[:id]
      place_id = permitted_params[:id]
      place_params = place_params.except!(:place_contract_attributes)
      place_params = place_params.except!(:place_hours_attributes)
      place = Place.find(permitted_params[:id])
      puts place_params
      place.update_attributes!(place_params)

      # puts contract_params
      
      if !hour_params.nil?
        hour_params.keys.each do |key|
          hour_param = hour_params[key]
          hour_param[:place_id] = place_id
          puts hour_param

          Time.zone = "UTC"
          open = Time.now.utc.beginning_of_day.advance(:hours => hour_param["open(4i)"].to_i, :minutes => hour_param["open(5i)"].to_i)
          close = Time.now.utc.beginning_of_day.advance(:hours => hour_param["close(4i)"].to_i, :minutes => hour_param["close(5i)"].to_i)
          puts "open: #{open}"
          puts "close: #{close}"

          if hour_param[:id].nil?  
            PlaceHour.create(:day_of_week => hour_param[:day_of_week], :open => open, :close => close, :place_id => place_id)
          else
            puts hour_param[:_destroy]
            if hour_param[:_destroy] == "1"
              puts "Going to destroy"
              PlaceHour.find(hour_param[:id]).destroy
            else
              PlaceHour.update(hour_param[:id], :day_of_week => hour_param[:day_of_week], :open => open, :close => close)
            end
          end
        end
      end

      if contract_params[:id].nil?
        contract_params = contract_params.except!(:_destroy)
        create_contract(contract_params, place)
      else
        if contract_params[:_destroy] == "1"
          PlaceContract.find(contract_params[:id]).destroy
        else
          PlaceContract.find(contract_params[:id]).destroy
          contract_params = contract_params.except!(:id)
          contract_params = contract_params.except!(:_destroy)
          create_contract(contract_params, place)
        end
      end

      redirect_to admin_place_path(place)

    end

    def create_contract(contract_params, place)        
      contract = PlaceContract.create(contract_params)
      if !contract.price.nil?
        place.workouts.where("start_time > ?", Time.now).update_all(:price => contract.price)
      elsif !contract.discount.nil?
        place.workouts.where("start_time > ?", Time.now).each do |workout|
          workout.price = ((1 - contract.discount) * workout.original_price).round
          workout.save
        end
      end
    end

    def permitted_params
      params.permit!
    end
  end
end

