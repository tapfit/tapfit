require_relative 'process_base'
require './lib/workout_key'

class ProcessClass < ProcessBase
  
  def initialize(opts={})
    if !opts.nil?
      @valid_keys = opts.keys
      @valid_keys = @valid_keys.collect{|i| i.to_s}
      @place_id = opts[:place_id]
      @name = opts[:name]
      @tags = opts[:tags]
      @source_description = opts[:source_description]
      @source = opts[:source]
      @source_id = opts[:source_id]
      @start_time = opts[:start_time]
      @end_time = opts[:end_time]
      @price = opts[:price]
      @instructor = opts[:instructor]
      @can_buy = opts[:can_buy]
    end
  end

  def save_to_database(source_name)
    if validate_crawler_values?(source_name)
      puts "failed to validate class"
    else
      place = Place.find(@place_id)
      if !@instructor.nil?
        full_name = @instructor.split(" ")
        first_name = full_name[0] if full_name.length > 0
        last_name = full_name[1] if full_name.length > 1
        instructor = place.instructors.where(:first_name => first_name, :last_name => last_name).first
        instructor = Instructor.create(:first_name => first_name, :last_name => last_name) if instructor.nil?
      end
      
      if place.can_buy
        @can_buy = true
      else
        @can_buy = false
      end

      workout_key = WorkoutKey.get_workout_key(@place_id, @name)

      if @source_description.nil?
        old_workout = Workout.where(:workout_key => workout_key).where("source_description IS NOT NULL").first
        if !old_workout.nil?
          @source_description = old_workout.source_description
        end
      end
      starts = self.change_date_to_utc(@start_time, place.address.timezone)
      ends = self.change_date_to_utc(@end_time, place.address.timezone)

      workout = Workout.where(:workout_key => workout_key).where(:start_time => starts).first
      if !workout.nil?
        puts "Workout already exists"
        return
      end
      workout = Workout.new(:name => @name, :place_id => @place_id, :source_description => @source_description, :start_time => starts.utc, :end_time => ends.utc, :price => @price, :instructor_id => instructor.id, :source => @source, :workout_key => workout_key, :is_bookable => @is_bookable, :can_buy => true)

      if !workout.valid?
        puts "errors: #{workout.errors}"
      end

      if workout.save
        puts "saved to database #{workout.name}, place_id: #{workout.place_id}"

        return workout.id  
      else
        puts "failed to save #{workout.errors}"
        return nil
      end
    end
  end

  def change_date_to_utc(time, timezone)
    Time.zone = timezone
    newTime = Time.zone.now.beginning_of_day.change(:year => time.year, :month => time.month, :day => time.day, :hour => time.hour)
    Time.zone = "UTC"
    return newTime
  end

end
