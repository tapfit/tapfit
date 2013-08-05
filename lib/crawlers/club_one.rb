require './lib/resque_job'
require 'nokogiri'
require 'open-uri'
Dir["./lib/crawler_validation/*.rb"].each { |file| require file }

class ClubOne < ResqueJob

  @source = "clubone"
  @base_url = "http://www.clubone.com"

  def self.perform(url, place_id, date)
    
    if url == 1
      self.get_locations(date)
    else
      date = DateTime.parse(date.to_s)
      self.get_classes(url, place_id, date)
    end
  end

  def self.get_classes(url, place_id, date)
    
    cmd = "phantomjs ./lib/phantomjs/get_page_with_js.js '#{url}' weekView"

    output = `#{cmd}`

    doc = Nokogiri::HTML(output)

    dayOfWeek = (date.wday == 0 ? 6 : date.wday - 1)
    puts dayOfWeek

    days = doc.xpath("//li[contains(@id, 'ctl0#{dayOfWeek}_lvWeekClasses')]")

    days.each do |day|

      ps = day.search("p")
      time = nil
      instructor = nil
      ps.each do |p|
        if p["class"] == "time"
          time = p.text.strip.gsub(/[^0-9A-Za-z: ]/, '-')
        end

        if p["class"] == "instructor"
          instructor = p.text.strip
        end
      end

      if !time.nil?
        start_time = Time.parse(time.split("-")[0].strip)
        end_time = Time.parse(time.split("-")[1].strip)
      end

      name = day.search("h1").first.text.strip
      description = ps[ps.length - 1].text.strip

      opts = {}
      opts[:name] = name
      opts[:instructor] = instructor
      opts[:place_id] = place_id
      starts = date.beginning_of_day.advance(:hours => start_time.hour, :minutes => start_time.strftime("%M").to_i)
      ends = date.beginning_of_day.advance(:hours => end_time.hour, :minutes => end_time.strftime("%M").to_i)
      opts[:start_time] = starts
      opts[:end_time] = ends
      opts[:source] = @source
      opts[:source_description] = description
      place = Place.where(:id => place_id).first
      if !place.nil? && place.dropin_price
        opts[:price] = place.dropin_price
      end

      process_class = ProcessClass.new(opts)
      process_class.save_to_database(@source) 

    end

  end

  def self.get_locations(date)
    url = "#{@base_url}/Clubs"

    doc = Nokogiri::HTML(open(url))

    links = doc.xpath("//div[@class='wrapper']")[2].search("a")

    links.each do |link|
      url = "#{@base_url}#{link["href"]}"

      place_id = ProcessLocation.get_place_id(@source, url)
      if place_id.nil? 
        
        name = "Club One"

        doc = Nokogiri::HTML(open(url))

        loc = doc.xpath("//div[@class='col locationDetails']").first

        address = {}
        split_address = loc.search("p").first.text.strip.split("\n")
        address[:line1] = split_address[0].gsub("\r", "").strip 
        address[:city] = split_address[1].gsub(/,\r/, "").strip
        address[:state] = split_address[2].gsub("\r", "").strip
        address[:zip] = split_address[3].strip
        
        numbers = loc.search("p")[1]
        numbers.search('br').each do |n|
          n.replace("\n")
        end
       
        club = loc.search("h4").first.text.strip.gsub(" ", "-") 
        schedule_url = "#{@base_url}/Classes?club=#{club}"

        opts = {}
        opts[:name] = name
        opts[:address] = address
        opts[:phone_number] = numbers.text.split("\n")[2].strip
        opts[:source] = @source
        opts[:url] = url
        opts[:source_id] = url
        opts[:category] = Category::Gym
        opts[:tags] = []
        opts[:schedule_url] = schedule_url
        opts[:dropin_price] = 20.00

        process_location = ProcessLocation.new(opts)
        place_id = process_location.save_to_database(@source)
      end

      place = Place.where(:id => place_id).first
      if !place.nil?
        puts "adding to resque"
        Resque.enqueue(self, place.schedule_url, place.id, date)
      end
    end
  end

end

