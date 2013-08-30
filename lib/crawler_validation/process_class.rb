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
      @is_day_pass = opts[:is_day_pass]
      @is_cancelled = opts[:is_cancelled]
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
        if "#{first_name} #{last_name}" == "Cancelled Today"
          puts "Workout cancelled today"
          return
        end
        instructor = place.instructors.where(:first_name => first_name, :last_name => last_name).first
        instructor = Instructor.create(:first_name => first_name, :last_name => last_name) if instructor.nil?
      end
      
      if place.can_buy
        @can_buy = true
      else
        @can_buy = false
      end

      workout_key = WorkoutKey.get_workout_key(@place_id, @name)

      if place.dropin_price.nil?
        old_workout = Workout.where(:workout_key => workout_key).where("price IS NOT NULL").order("start_time DESC").first
        if !old_workout.nil?
          @price = old_workout.price
        end
      end

      original_price = @price
      if !place.place_contract.nil?
        @price = place.place_contract.price
      end

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
        if @is_cancelled == true
          puts "Updating workout to is_cancelled"
          workout.update_attributes(:is_cancelled => true)
        end
        return
      end
      puts "is_cancelled: #{@is_cancelled}"
      if @is_cancelled.nil?
        @is_cancelled = false
      end

      if @is_day_pass.nil?
        @is_day_pass = false
      end
      workout = Workout.new(:name => @name, :place_id => @place_id, :source_description => @source_description, :start_time => starts.utc, :end_time => ends.utc, :price => @price, :instructor_id => instructor.id, :source => @source, :workout_key => workout_key, :is_bookable => @is_bookable, :can_buy => true, :is_day_pass => @is_day_pass, :original_price => original_price, :is_cancelled => @is_cancelled)
      
      workout.is_day_pass = @is_day_pass 

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
    newTime = Time.zone.now.beginning_of_day.change(:year => time.year, :month => time.month, :day => time.day, :hour => time.hour, :min => time.strftime("%M").to_i )
    Time.zone = "UTC"
    return newTime
  end

end
