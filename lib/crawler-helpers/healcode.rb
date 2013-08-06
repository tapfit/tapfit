
module Healcode
  
  def self.get_classes(url, place_id, date, source)

    cmd = "phantomjs ./lib/phantomjs/get_page_with_js.js #{url} mbo_class"

    output = `#{cmd}`
    
    doc = Nokogiri::HTML(output)

    # puts doc

    header = doc.xpath("//table[starts-with(@class, 'schedule filtered_collection')]")

    # puts header
    num = 0
    table = header.children[0].children
    date_string = date.strftime("%B %-d, %Y")
    puts "Table length: #{table.length}"
    # puts "Table: #{table}"
    scrape_classes = false
    while num < table.length do
      if table[num]['class'] == "schedule_header"
        if table[num].text.include?(date_string)
          # puts "About to set scrape to true"
          scrape_classes = true
        else
          # puts "About to set scrape to false: #{table[num].text}, date_string: #{date_string}"
          scrape_classes = false
        end
      else
        if scrape_classes
          puts "About to scrape classes"
          node = table[num]
          
          opts = {}
          i = 0
          while i < node.children.length do
            if node.children[i]['class'] == "mbo_class"
              opts[:name] = node.children[i].text.gsub(/[\n\t\r]/, "").strip
            elsif node.children[i]['class'] == "trainer"
              opts[:instructor] = node.children[i].text.gsub(/[\n\t\r(sub)]/, "").strip
            end
            i = i + 1
          end
          opts[:place_id] = place_id
          opts[:tags] = ["Yoga"]
          times = node.children[0].text.split("-")
          starts = Time.parse(times[0])
          ends = Time.parse(times[1])
          opts[:start_time] = date.beginning_of_day.advance(:hours => starts.strftime("%H").to_i, :minutes => starts.strftime("%M").to_i)      
          opts[:end_time] = date.beginning_of_day.advance(:hours => ends.strftime("%H").to_i, :minutes => ends.strftime("%M").to_i)
          opts[:source] = source
          opts[:price] = Place.find(place_id).dropin_price

          process_class = ProcessClass.new(opts)
          process_class.save_to_database(source)

        end
      end
      num = num + 1
    end

    # puts header

    doc.xpath("//tr[contains(@class, 'DropIn')]").each do |node|
      opts = {}
      num = 0
      while num < node.children.length do
        if node.children[num]['class'] == "mbo_class"
          opts[:name] = node.children[num].text.gsub(/[\n\t\r]/, "").strip
        elsif node.children[num]['class'] == "trainer"
          opts[:instructor] = node.children[num].text.gsub(/[\n\t\r(sub)]/, "").strip
        end
        num = num + 1
      end
      opts[:place_id] = place_id
      opts[:tags] = ["Yoga"]
      times = node.children[0].text.split("-")
      starts = Time.parse(times[0])
      ends = Time.parse(times[1])
      opts[:start_time] = date.beginning_of_day.advance(:hours => starts.strftime("%H").to_i, :minutes => starts.strftime("%M").to_i)      
      opts[:end_time] = date.beginning_of_day.advance(:hours => ends.strftime("%H").to_i, :minutes => ends.strftime("%M").to_i)
      opts[:source] = source
      opts[:price] = Place.find(place_id).dropin_price
      process_class = ProcessClass.new(opts)
      # process_class.save_to_database(source)
    end

  end
end
