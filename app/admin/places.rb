require "./lib/crawler_validation/process_location"
require "./lib/crawler-helpers/casper_mindbody"

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

  filter :name, :label => "Name"
  filter :address_city, :label => "City", :as => :string
  filter :source


  member_action :get_classes, :method => :get do

    place = Place.find(params[:id])
    CasperMindbody.get_classes(place.schedule_url, place.id, DateTime.now, place.source)
    CasperMindbody.get_classes(place.schedule_url, place.id, DateTime.now + 1.days, place.source) 
    redirect_to "/admin/places/#{params[:id]}"
  end

  action_item :only => :show do
    link_to("Get Classes", get_classes_admin_place_path(place)) if place.can_buy
  end 
  
  action_item :only => :show do 
    link_to('Add a Photo', new_place_photo_path(place))
  end

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
      f.input :pass_detail_info, :as => :number
       
      f.has_many :place_hours do |hour|
        hour.input :day_of_week
        hour.input :open, :as => :time_picker
        hour.input :close, :as => :time_picker
        hour.input :_destroy, :as=>:boolean, :required => false, :label => 'Delete Hour'
      end
    end

    f.inputs "Address", :for => [ :address, f.object.address || Address.new] do |address|
      address.input :line1
      address.input :line2
      address.input :city
      address.input :state
      address.input :zip
      address.input :lat
      address.input :lon
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

    def create
      place_params = permitted_params[:place]
      address_params = place_params[:address]
      id = ProcessLocation.controller_helper(place_params, address_params)
     
      place = Place.find(id)
      
      update_place_attributes(place.id)

      place = Place.find(id)

      if place.facility_type == 1 || place.facility_type == 2
        place.place_hours.each do |hour|
          DayPass.create_day_pass(place, hour, DateTime.now)
          DayPass.create_day_pass(place, hour, DateTime.now + 1.days)
        end
      end

    end

    def update

      place_params = permitted_params[:place]
      address_params = place_params[:address]
      attribute_params = place_params.clone
      place_params = attribute_params.except!(:place_contract_attributes)
      place_params = place_params.except!(:place_hours_attributes)
      place_params = place_params.except!(:pass_detail_info)
      place_params = place_params.except!(:address)
      place = Place.find(permitted_params[:id])

      address = place.address

      if address.nil?
        place.address = Address.create(address_params)
      else
        address.update_attributes!(address_params)
      end

      place.update_attributes!(place_params)

      update_place_attributes(place.id)
    end

    def update_place_attributes(place_id)
      place_params = permitted_params[:place]
      contract_params = place_params[:place_contract_attributes]
      puts contract_params
      hour_params = place_params[:place_hours_attributes]
      pass_detail = place_params[:pass_detail_info]
      if !contract_params.nil?
        contract_params[:place_id] = place_id
      end
      place = Place.find(place_id)
      
      if !hour_params.nil?
        hour_params.keys.each do |key|
          hour_param = hour_params[key]
          hour_param[:place_id] = place_id
          puts hour_param

          Time.zone = "UTC"
          open = Time.parse(hour_param["open"])
          close = Time.parse(hour_param["close"])
          open = Time.now.utc.beginning_of_day.advance(:hours => open.hour, :minutes => open.min)
          close = Time.now.utc.beginning_of_day.advance(:hours => close.hour, :minutes => close.min)
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
      
      if !contract_params.nil?
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
      end

      # Create pass detail - RETHINK IF WE HAVE MULTIPLE PASS DETAILS FOR A PLACE
      if pass_detail.nil?
        if place.pass_details.count > 0
          place.pass_details.destroy_all
        end
        PassDetail.create(:place_id => place.id, :pass_type => 0)
      else
        if place.pass_details.count > 0 
          if !(place.pass_details.first.pass_type == pass_detail)
            place.pass_details.destroy_all
            PassDetail.create(:place_id => place.id, :pass_type => pass_detail)
          end
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

