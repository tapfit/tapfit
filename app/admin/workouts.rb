require './lib/crawler_validation/process_class'

ActiveAdmin.register Workout do

  index do
    column :name
    column :start_time
    column :end_time
    column :source_description
    column :can_buy
    column :price
    column :is_day_pass
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

  member_action :update_prices, :method => :get do
    workout = Workout.find(params[:id])
    Workout.where(:workout_key => workout.workout_key).update_all(:price => workout.price)
    redirect_to admin_workouts_path
  end

  action_item :only => :show do
    link_to("Update Descriptions", update_description_admin_workout_path(workout)) if !workout.source_description.nil? 
  end

  action_item :only => :show do
    link_to("Update Prices", update_prices_admin_workout_path(workout)) if !workout.price.nil?
  end

  form do |f|
    f.inputs "Workout" do
      f.input :name
      f.input :source_description
      f.input :can_buy
      f.input :start_time
      f.input :end_time
      f.input :price
      f.input :is_day_pass
      f.input :place_id
    end
    
    f.inputs "Instructor", :for => [:instructor, f.object.instructor || Instructor.new] do |meta_form|
      meta_form.input :first_name
      meta_form.input :last_name
    end

    f.actions
  end

  controller do

    def new
      @workout = Workout.new
      @workout.start_time = Time.now.change(:min => 0, :sec => 0)
      @workout.end_time = Time.now.change(:min => 0, :sec => 0)
    end

    def create
      
      workout = permitted_params[:workout]
      instructor = "#{workout[:instructor][:first_name]} #{workout[:instructor][:last_name]}"
      workout = workout.except!(:instructor)
      workout = Workout.new(workout)

      place = Place.find(workout.place_id)

      workout.can_buy = false if workout.can_buy.nil?
      workout.is_day_pass = false if workout.is_day_pass.nil?

      puts "is_day_pass: #{workout.is_day_pass}"

      opts = {}
      opts[:name] = workout.name
      opts[:place_id] = workout.place_id
      opts[:start_time] = workout.start_time
      opts[:end_time] = workout.end_time
      opts[:price] = workout.price
      opts[:can_buy] = workout.can_buy
      opts[:is_day_pass] = workout.is_day_pass
      opts[:source_description] = workout.source_description
      opts[:instructor] = instructor

      process_class = ProcessClass.new(opts)
      workout = process_class.save_to_database("admin")

      redirect_to admin_workout_path(workout) 
    end

    def permitted_params
      params.permit!
    end
  end
end
