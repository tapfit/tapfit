require 'nokogiri'
require 'open-uri'
require './lib/resque_job'
require './lib/crawler-helpers/healcode'

class CorePower < ResqueJob

  @source = "corepower"
  @base_url = "http://www.corepoweryoga.com"

  def self.perform(url, schedule, date)
    if url == 1
      CorePower.get_studio_urls
    else
      puts "About to get classes"
      CorePower.get_class_info(date, url, schedule) 
    end
  end

  def self.get_studio_urls(date)
    doc = Nokogiri::HTML(open("http://www.corepoweryoga.com/yoga-studio"))
    doc.xpath("//a[@class='studio-link']").each do |loc|
      url = "#{@base_url}#{loc['href']}"
      schedule = loc.parent.children[1]
      schedule_url = "#{@base_url}#{schedule['href']}"
      if !schedule_url.nil? && schedule_url != ""
        puts url
        puts schedule_url
        Resque.enqueue(CorePower, url, schedule_url, date)
      end
    end
  end

  def self.get_class_info(date, url, schedule_url)
    place_id = CorePower.get_location_info(url, schedule_url)
    if place_id.nil?
      puts "couldn't find class"
      return
    end

    doc = Nokogiri::HTML(open(schedule_url))

    content = doc.xpath("//iframe").first

    schedule_url = "#{@base_url}#{content['src']}"
    
    puts schedule_url

    Healcode.get_classes(schedule_url, place_id, date, @source)  

  end

  def self.get_location_info(url, schedule_url)
    puts "url: #{url}, schedule_url: #{schedule_url}"
    place_id = ProcessLocation.get_place_id(@source, url)
    if place_id.nil?
      begin
        name = "Core Power Yoga"
        doc = Nokogiri::HTML(open(url))
        doc.search('br').each do |n|
            n.replace("\n")
        end
        content = doc.xpath("//span[@class='Normal']")
        description = doc.xpath("//img[starts-with(@style, 'width: 300px;')]").first

        source_description = description.parent.text
        info = nil
        if content.length == 0
          content = doc.xpath("//div[@class='content white-content-area']").first
          content.children.each do |p|
            if p.text.split("\n").length >= 3
              info = p.text.split("\n")
            end
          end
          if info.nil?
            puts "Couldn't find address"
            return
          end
        elsif content.length > 1
          info = content[0].text.split("\n") + [content[1].text]
        else
          info = content.text.split("\n")
        end
        phone_number = info[info.length - 1]
        line1 = info[0]
        address = {}
        address[:line1] = line1
        Crawler.separate_city_state_zip(address, info[info.length - 2])
        opts = {}
        opts[:name] = name
        opts[:address] = address
        opts[:phone_number] = phone_number
        opts[:source_description] = source_description
        opts[:source] = @source
        opts[:source_id] = url
        opts[:url] = url
        opts[:category] = Category::Yoga
        opts[:tags] = ["Yoga", "Hot Yoga", "Power Yoga"]
        opts[:schedule_url] = schedule_url
        opts[:dropin_price] = 20.00

        process_location = ProcessLocation.new(opts)
        place_id = process_location.save_to_database(@source)    
      rescue => e
        puts "ran into issues: #{e}"
        MailerUtils.write_error("#{name} - #{e}", url, @source)
        return
      end
    end
    return place_id
  end
end
