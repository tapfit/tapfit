require 'nokogiri'
require './lib/resque_job'

class Fitness24Hour < ResqueJob

  @source = "24hourfitness"

  @base_url = "http://www.24hourfitness.com/FindClubDetail.mvc?clubid="
  @base_schedule_url = "http://24hourfit.schedulesource.com/public/gxschedule.aspx?club="

  def self.perform(url, place_id, date)
      
    if url == 1      
      num = 2
      while num < 1050
        Resque.enqueue(Fitness24Hour, num, nil, date)
        num += 1
      end
    end

    Fitness24Hour.get_classes(url, date)

  end

  def self.get_classes(num, date)

    place_id = ProcessLocation.get_place_id(@source, num)
    if place_id.nil?
      place_id = self.get_location_info_and_save(num)
    end

    if !place_id.nil?
      self.save_classes_to_database(num, place_id, date)
    end

  end

  def self.save_classes_to_database(num, place_id, date)
    
    date = Time.parse(date.to_s)
    url = "http://24hourfit.schedulesource.com/public/gxschedule.aspx?date="

    url = "#{url}#{date.strftime("%m/%d/%Y")}&club=#{num}&type=time"

    doc = Nokogiri::HTML(open(url))
    
    dayOfWeek = (date.wday == 0 ? 6 : date.wday - 1) + 1 
    table = doc.xpath("//table[@frame='box']").first
 
    num = 1
    table.search("tr").each do |tr|
      if num == 1
        num += 1
        next
      end

      tds = tr.search("td")
      start_time = tds[0].text
      
      if tds.text.strip != ""
        
        opts = {}
        opts[:place_id] = place_id
        starts = Time.parse(start_time)
        opts[:start_time] = date.beginning_of_day.advance(:hours => starts.hour, :minutes => starts.strftime("%M").to_i)
        opts[:end_time] = date.beginning_of_day.advance(:hours => starts.hour + 1, :minutes => starts.strftime("%M").to_i)
        opts[:source] = @source
        td = tds[dayOfWeek]
        td.search("br").each do |n|
          n.replace("\n")
        end
        if td.search("img").length > 0
          link = td.search("img").first["src"].split("/")
          class_name = link[link.length - 1].split(".")[0].capitalize
          opts[:name] = class_name          
          teacher = td.text.strip
          opts[:instructor] = teacher
        else
          classes = td.text.split("\n")
          if classes.length > 1
            classes.delete(" ")
            classes.delete("\r")
            class_name = classes[0]
            teacher = classes[classes.length - 1]
            opts[:name] = class_name
            opts[:instructor] = teacher
          end
        end
       
        if !opts[:name].nil? 
          process_class = ProcessClass.new(opts)
          process_class.save_to_database(@source)
        end

      end
    end

    
  end

  def self.get_location_info_and_save(num)

    url = "#{@base_url}#{num}"
      
    doc = Nokogiri::HTML(open(url))

    doc.search("input").each do |input|
      if input["id"] == "btnFindClub1"
        puts "Going on to next"
        next
      end
    end

    clubInfo = doc.xpath("//div[@class='gridRow clubInfo']").first

    if clubInfo.nil?
      puts "No gym at this num: #{num}"
      return
    end

    puts clubInfo.children.count

    clubInfo.search("br").each do |n|
      n.replace("\n")
    end
    
    address = {}
    phone_number = ""

    clubInfo.children.each do |info|
      if info.text.include?("Map & Directions")
        location = info.text.split("\n")
        phone_number = location[location.length - 1]
        address[:line1] = location[0]
        Crawler.separate_city_state_zip(address, location[1])
      end
    end

    amenities = doc.xpath("//ul[@class='amenities']").first

    tags = []
    amenities.children.each do |amenity|
      if amenity.name == "li"
        tags << amenity.text
      end
    end

    tags << Category::Gym
    opts = {}
    opts[:name] = "24 Hour Fitness"
    opts[:tags] = tags
    opts[:phone_number] = phone_number
    opts[:url] = url
    opts[:schedule_url] = "#{@base_schedule_url}#{num}"
    opts[:source] = @source
    opts[:address] = address
    opts[:source_id] = num
    opts[:category] = Category::Gym
    
    process_location = ProcessLocation.new(opts)
    process_location.save_to_database(@source)
  end

end
