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
      @class_id = opts[:class_id]
      @is_day_pass = opts[:is_day_pass]
      @is_cancelled = opts[:is_cancelled]
    end
  end

  def save_to_database(source_name)
    if validate_crawler_values?(source_name)
      puts "failed to validate class"
    else
      place = Place.find(@place_id)
      instructor_id = nil
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
        instructor_id = instructor.id
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
          @price = old_workout.original_price
          if @price.nil?
            @price = old_workout.price
          end
        end
      else
        @price = place.dropin_price
      end

      original_price = @price
      if !place.place_contract.nil?
        if place.place_contract.price.nil?
          if !place.place_contract.discount.nil? && !@price.nil?
            begin
              @price = ((1 - place.place_contract.discount) * @price).round
            rescue
              puts "discount: #{place.place_contract.discount}, price: #{@price}"
            end
          end
        else
          @price = place.place_contract.price
        end
        old_workout = Workout.where(:workout_key => workout_key).where("price IS NOT NULL").order("start_time DESC").first
        if !old_workout.nil?
          original_price = old_workout.original_price
        end

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
        if !@is_cancelled.nil? && @is_cancelled
          puts "Updating workout to is_cancelled"
          if place.id != 1931 && place.id != 2308
            workout.update_attributes(:is_cancelled => true)
          end
        end
        update_lowest_price(place.id)
        return
      end
      puts "is_cancelled: #{@is_cancelled}"
      if @is_cancelled.nil?
        @is_cancelled = false
      end

      crawler_info = nil
      if !@class_id.nil?
        crawler_info = { :class_id => @class_id }
      end

      if @is_day_pass.nil?
        @is_day_pass = false
      end
      
      if place.id == 1931 || place.id == 2308
        @is_cancelled = false
      end

      pass_detail = place.pass_details.first
      pass_detail_id = nil
      if !pass_detail.nil?
        pass_detail_id = pass_detail.id
      end

      workout = Workout.new(:name => @name, :place_id => @place_id, :source_description => @source_description, :start_time => starts.utc, :end_time => ends.utc, :price => @price, :instructor_id => instructor_id, :source => @source, :workout_key => workout_key, :is_bookable => @is_bookable, :can_buy => true, :is_day_pass => @is_day_pass, :original_price => original_price, :is_cancelled => @is_cancelled, :pass_detail_id => pass_detail_id, :crawler_info => crawler_info)
      
      workout.is_day_pass = @is_day_pass 

      if !workout.valid?
        puts "errors: #{workout.errors}"
      end

      
      if workout.save
        puts "saved to database #{workout.name}, place_id: #{workout.place_id}"
        update_lowest_price(workout.place_id)
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

  def update_lowest_price(place_id)
    place = Place.find(place_id)
    lowest_price_workout = place.todays_workouts.order("price ASC").first
    if !lowest_price_workout.nil?
      place.lowest_price = lowest_price_workout.price
      place.lowest_original_price = lowest_price_workout.original_price
      place.save
    end
  end
end
