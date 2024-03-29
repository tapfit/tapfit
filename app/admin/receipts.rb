ActiveAdmin.register Receipt do

  index do
    column "Place" do |i|
      i.place.name if !i.place.nil?
    end

    column "Workout Name" do |i|
      if !i.workout.nil?
        i.workout.name 
      end
    end

    column "Workout start time" do |i|
      i.workout.local_start_time if !i.workout.nil?
    end

    column "Schedule Url" do |i|
      i.place.schedule_url if !i.place.nil?
    end

    column "Url" do |i|
      i.place.url if !i.place.nil?
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

  config.sort_order = "has_booked_asc"

  filter :has_booked, :as => :select

  form do |f|
    f.inputs "Receipt Details" do
      f.input :has_booked
      f.input :has_used
      f.input :price
    end
    f.actions
  end 
  
  controller do

    def update
      update! do |format|
        format.html { redirect_to admin_receipts_path }
      end
    end

    def permitted_params
      params.permit!
    end
  end
end
