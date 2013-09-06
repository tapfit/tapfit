module DayPass

  def self.create_day_pass(place, hour, date)
   
    if date.wday == hour.day_of_week 
      
      puts "Adding day pass for #{date}"
      opts = {}
      opts[:name] = "Day Pass"
      opts[:tags] = ["Gym"]
      
      starts = date.beginning_of_day.advance(:hours => hour.open.hour, :minutes => hour.open.min)
      ends = date.beginning_of_day.advance(:hours => hour.close.hour, :minutes => hour.close.min)

      opts[:start_time] = starts
      opts[:end_time] = ends
      opts[:price] = place.dropin_price
      opts[:source] = place.source
      opts[:place_id] = place.id
      opts[:instructor] = "Open Gym"
      opts[:is_day_pass] = true
      opts[:source_description] = "Get full access to our facilities. Whether you want to run on the treadmill, lift weights or try one of our classes, we have you covered."

      process_class = ProcessClass.new(opts)
      process_class.save_to_database(place.source)

    end
  end

end
