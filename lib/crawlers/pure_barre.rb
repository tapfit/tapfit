require './lib/resque_job'
require 'nokogiri'
require 'open-uri'
Dir["./lib/crawler_validation/*.rb"].each { |file| require file }

class PureBarre < ResqueJob

  @source = "purebarre"
  @base_url = "http://www.purebarre.com/"

  def self.perform(url, place_id, date)
    
    # return
    if url == 1
      PureBarre.get_locations(date)
    else
      # Mindbody.get_classes(url, place_id, date, source)
      PureBarre.get_class(url, place_id, date) 
    end
  end


  def self.get_class(url, place_id, date)

    puts "url: #{url}, place_id: #{place_id}, date: #{date}"

    cmd = "phantomjs ./lib/phantomjs/get_frame.js '#{url}' evenRow"

    output = `#{cmd}`

    doc = Nokogiri::HTML(output)

    content = doc.xpath("//table[@id='classSchedule-mainTable']").first

    num = 0

    while content.nil? && num < 5
      sleep(1)
      output = `#{cmd}`
      content = doc.xpath("//table[@id='classSchedule-mainTable']").first 
      num = num + 1
    end

    if content.nil?
      # puts output
      puts "Content is nil for url: #{url}"
      return
    end

    scrape_classes = false
    content.search("tr").each do |row|
      # puts "row: #{row.text}, scrape_classes: #{scrape_classes}"
      if (row["class"] == "oddRow" || row["class"] == "evenRow") && scrape_classes
       
        opts = {}
         
        tds = row.search("td")

        starts = Time.parse(tds[0].text)

        # Need to parse DateTime because in resque, they convert all types to string

        opts[:start_time] = DateTime.parse(date.to_s).beginning_of_day.advance(:hours => starts.strftime("%H").to_i, :minutes => starts.strftime("%M").to_i)
        opts[:end_time] = opts[:start_time].advance(:hours => 1)        

        opts[:name] = "%"
        row.search("a").each do |link|
          if link["class"] == "modalClassDesc"
            opts[:name] = link.text.strip
          end
        end
        place = Place.where(:id => place_id).first 
        opts[:instructor] = tds[tds.length - 2].text.split("(")[0].strip
        opts[:source] = @source
        
        if !place.nil? && !place.dropin_price.nil?
          opts[:price] = place.dropin_price
        end

        opts[:tags] = [ Category::PilatesBarre ]
        opts[:place_id] = place_id

        puts opts
        process_class = ProcessClass.new(opts)
        process_class.save_to_database(@source) 

      else
        begin
          # puts row.text
          date_string = DateTime.parse(date.to_s).strftime("%B %d, %Y")
          puts date_string
          if row.text.include?(date_string)
            puts "scrape_classes = true"
            scrape_classes = true
          else
            puts "scrape_classes = false"
            scrape_classes = false
          end
        rescue => e
          puts "Failed to parse row.text: #{row.text}, e: #{e}"
          scrape_classes = false
        end
      end
    end

    return
  end

  def self.get_locations(date)
    url = "#{@base_url}p-locations.html"

    doc = Nokogiri::HTML(open(url))

    table = doc.xpath("//div[@class='locations-box-main']").first

    states = table.search("a")

    states.each do |state|
      url = "#{@base_url}#{state["href"]}"
      doc = Nokogiri::HTML(open(url))

      table = doc.xpath("//div[@class='locations-box']").first

      places = table.search("a")

      places.each do |place|
        url = "#{@base_url}#{place["href"]}"

        place_id = ProcessLocation.get_place_id(@source, url)
        if place_id.nil?
          name = "Pure Barre"

          doc = Nokogiri::HTML(open(url))
          doc.search('br').each do |n|
            n.replace("\n")
          end
          
          content = doc.xpath("//div[@id='content']").first
          if !content.text.upcase.include?("COMING SOON")

            schedule_url = ""
            content.search("a").each do |link|

              if link.text.upcase.include?("SCHEDULE")
                schedule_url = link["href"]
                break
              end
            end

            array = content.text.split("\n").map { |f| f.strip }

            array.delete("")
            num = 0
            while num < array.length do
              line = array[num]
              if line.include?("ph")

                address = {}

                Crawler.separate_city_state_zip(address, array[num - 1])
                
                if num == 3
                  address[:line1] = array[num - 2]
                elsif num > 3
                  address[:line1] = array[num - 3]
                  address[:line2] = array[num - 2]
                end

                opts = {}
                opts[:name] = "Pure Barre"
                opts[:address] = address
                opts[:tags] = ["Barre"]
                opts[:phone_number] = line.split(" ")[1]
                opts[:category] = Category::PilatesBarre
                opts[:source] = @source
                opts[:url] = url
                opts[:schedule_url] = schedule_url
                opts[:source_id] = url
                # opts[:schedule_url] = schedule_url

                process_location = ProcessLocation.new(opts)
                place_id = process_location.save_to_database(@source)
                break
              end
              num = num + 1
            end

          end
        end

        place = Place.where(:id => place_id).first

        puts "Resque.enqueue(PureBarre, place.schedule_url, place.id, date)"

        Resque.enqueue(PureBarre, place.schedule_url, place.id, date) if !place.nil?

      end
    end
  end
end
