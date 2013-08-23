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

  member_action :update_description, :method => :get do
    workout = Workout.find(params[:id])
    Workout.where(:workout_key => workout.workout_key).update_all(:source_description => workout.source_description)
    redirect_to admin_workouts_path
  end

  action_item :only => :show do
    link_to("Update Descriptions", update_description_admin_workout_path(workout)) if !workout.source_description.nil? 
  end

  form do |f|
    f.inputs "Workout" do
      f.input :name
      f.input :source_description
      f.input :can_buy
      f.input :start_time
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
