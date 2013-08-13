ActiveAdmin.register Receipt do

  index do
    column "Place" do |i|
      i.place.name
    end

    column "Workout Name" do |i|
      i.workout.name
    end

    column "Workout start time" do |i|
      i.workout.start_time
    end

    column "Schedule Url" do |i|
      i.place.schedule_url
    end

    column "Url" do |i|
      i.place.url
    end

    column "First Name" do |i|
      i.user.first_name
    end

    column "Last Name" do |i|
      i.user.last_name
    end

    column :price
    column :has_booked
    column :has_used

    default_actions 
  end

  config.sort_order = "has_booked_desc"

  filter :has_booked

  form do |f|
    f.inputs "Receipt Details" do
      f.input :has_booked
      f.input :has_used
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
