ActiveAdmin.register Workout do

  index do
    column :name
    column :start_time
    column :end_time
    column :source_description
    column :can_buy
    column :price
    column "Place Name" do |i|
      i.place.name
    end 

    default_actions
  end

  filter :can_buy
  filter :place_name, :label => "Place Name", :as => :string
  filter :start_time

  form do |f|
    f.inputs "Workout" do
      f.input :name
      f.input :source_description
      f.input :can_buy
      f.input :price
    end

    f.actions
  end

  controller do
    def permitted_params
      params.permit!
    end
  end
end
