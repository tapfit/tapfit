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
      PureBarre.get_class(url, place_id, date) 
    end
  end

  def self.get_class(url, place_id, date)
    puts "Need to implement get classes"
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
                process_location.save_to_database(@source)
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
