module Zenplanner

  def self.get_classes(url, place_id, date, source)
    
    url = "#{url}?VIEW=MONTH&DATE=#{date.strftime("%Y-%m-%d")}&FRAME=false"

    cmd = "phantomjs ./lib/phantomjs/get_page_with_js.js '#{url}' dayLabel"

    output = `#{cmd}`

    # puts output

    doc = Nokogiri::HTML(output)

    dayLabel = date.strftime("%-d")

    puts "day: #{dayLabel}"
    
    content = doc.xpath("//div[@class='dayLabel']")

    content.each do |text|
      
      if text.text == dayLabel
        # puts "Found the date: #{dayLabel}"
        text.parent.children.each do |child| 
          if !child['class'].nil? && child['class'].include?("clickable") && !(child['class'].include?("sessionFull") || child['class'].include?("RED"))
            if child.text.include?("AM")
              time = child.text.split("AM")[0]
              name = child.text.split("AM")[1].split("(")[0]
              time = DateTime.parse("#{time.strip} AM")
              time = time.change(:month => date.month, :day => date.day)
              Zenplanner.save_to_database(name, time, place_id)
            elsif child.text.include?("PM")
              time = child.text.split("PM")[0]
              name = child.text.split("PM")[1].split("(")[0]
              time = DateTime.parse("#{time.strip} PM")
              time = time.change(:month => date.month, :day => date.day)
              Zenplanner.save_to_database(name, time, place_id)              
            end
          end
        end
      end

    end 

  end

  def self.save_to_database(name, start_time, place_id)
    opts = {}
    opts[:start_time] = start_time
    opts[:end_time] = start_time.advance(:hours => 1)

    opts[:name] = name
    opts[:instructor] = "PunchHouse Trainer"
    opts[:source] = "zenplanner"
    
    opts[:place_id] = place_id
    opts[:tags] = [ Category::MartialArts, Category::Cardio, Category::Sports, Category::Strength ]

    process_class = ProcessClass.new(opts)
    process_class.save_to_database("zenplanner")
  end

end
