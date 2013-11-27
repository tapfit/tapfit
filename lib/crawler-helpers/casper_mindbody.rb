
module CasperMindbody

  def self.get_classes(url, place_id, date, source)

    cmd = "casperjs ./lib/casperjs/mindbody.js --url='#{url}' --date='#{date.strftime("%m/%d/%Y")}'"

    output = `#{cmd}`

    parsed = ""
    begin
      parsed = JSON.parse(output)
    rescue
      return 
    end

    place = Place.find(place_id)

    parsed.each do |key, value|
      puts "key: #{key}"
      date_string = DateTime.parse(date.to_s).strftime("%B %d, %Y")
      if key.include?(date_string) 
        value.each do |workout|
          opts = {}

          if !workout['signup_button'].to_s.upcase.include?("SIGNUP")
            opts[:is_cancelled] = true
          else
            button = Nokogiri::HTML(workout['signup_button'])
            classId = button.to_s.split('classId=')[1].split('&')[0]
            if !classId.nil?
              opts[:class_id] = classId
            end
          end

          
          if workout['signup_button'].to_s.include?("Open")
            button = Nokogiri::HTML(workout['signup_button'])
            text = button.text
            nbsp = Nokogiri::HTML("&nbsp;").text
            array = button.content.split(nbsp)
            if array[3].to_i == 0
              opts[:is_cancelled] = true
            end
          end

          begin
            starts = Time.parse(workout['start_time'].strip)
          rescue
            return
          end
          opts[:start_time] = DateTime.parse(date.to_s).beginning_of_day.advance(:hours => starts.strftime("%H").to_i, :minutes => starts.strftime("%M").to_i)
          opts[:end_time] = opts[:start_time].advance(:hours => 1)

          opts[:name] = workout['name'].strip

          opts[:instructor] = workout['instructor'].split("(")[0].strip
          opts[:source] = source
          if !workout['description'].nil?
            opts[:source_description] = workout['description'].strip
          end
          if !place.nil? && !place.dropin_price.nil?
            opts[:price] = place.dropin_price
          else
            old_workout = place.workouts.where(:workout_key => WorkoutKey.get_workout_key(place.id, opts[:name])).order("start_time DESC").first
            if !old_workout.nil?
              opts[:price] = old_workout.price
            end
          end

          opts[:place_id] = place_id

          process_class = ProcessClass.new(opts)
          process_class.save_to_database(source)
        end
      end
    end

    

  end

end
