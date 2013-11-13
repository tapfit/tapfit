
module Mindbody

  def self.get_classes(url, place_id, date, source)

    url = "#{url}&sDate=#{date.strftime("%m/%d/%Y")}"

    cmd = "phantomjs ./lib/phantomjs/get_frame.js '#{url}' evenRow"

    output = `#{cmd}`

    doc = Nokogiri::HTML(output)

    content = doc.xpath("//table[@id='classSchedule-mainTable']").first

    num = 0

    while content.nil? && num < 5
      sleep(1)
      output = `#{cmd}`
      puts output
      content = doc.xpath("//table[@id='classSchedule-mainTable']").first 
      num = num + 1
    end

    if content.nil?
      return
    end

    scrape_classes = false
    content.search("tr").each do |row|
      # puts "row: #{row.text}, scrape_classes: #{scrape_classes}"
      if (row["class"] == "oddRow" || row["class"] == "evenRow") && scrape_classes

        opts = {}
        if !row.to_s.upcase.include?("SIGNUP")
          puts "Can't sign up for this class"
          opts[:is_cancelled] = true
        end
         
        tds = row.search("td")

        if tds[1].text.include?("Open")
          text = tds[1].text
          nbsp = Nokogiri::HTML("&nbsp;").text
          puts "text: #{tds[1].text.to_s.strip}"
          array = tds[1].content.split(nbsp)
          puts "array: #{array}"
          if array[3].to_i == 0
            puts "0 spots open in this class"
            opts[:is_cancelled] = true
          end 
        end
        starts = Time.parse(tds[0].text)

        puts "starts: #{starts}"
        # Need to parse DateTime because in resque, they convert all types to string

        puts tds
        puts tds[3].text.split("(")[0].strip

        opts[:start_time] = DateTime.parse(date.to_s).beginning_of_day.advance(:hours => starts.strftime("%H").to_i, :minutes => starts.strftime("%M").to_i)
        opts[:end_time] = opts[:start_time].advance(:hours => 1)    

        puts "start_time: #{opts[:start_time]}"    

        opts[:name] = tds[2].text.strip
        place = Place.where(:id => place_id).first 
        opts[:instructor] = tds[3].text.split("(")[0].strip
        opts[:source] = source
        
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

      else
        begin
          date_string = DateTime.parse(date.to_s).strftime("%B %d, %Y")
          if row.text.include?(date_string)
            scrape_classes = true
          else
            scrape_classes = false
          end
        rescue => e
          scrape_classes = false
        end
      end
    end

  end

end
