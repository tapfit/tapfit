require 'nokogiri'
require 'open-uri'
require './lib/resque_job'

class CorePower < ResqueJob

  @source = "corepower"
  @base_url = "http://www.corepoweryoga.com"

  def self.perform(url, schedule, name)
    if url == 1
      CorePower.get_studio_urls
    else
      
    end
  end

  def self.get_studio_urls
    doc = Nokogiri::HTML(open("http://www.corepoweryoga.com/yoga-studio"))
    doc.xpath("//a[@class='studio-link']").each do |loc|
      url = "#{@base_url}#{loc['href']}"
      schedule = loc.parent.children[1]
      name = schedule.text.split("-")[0].strip
      schedule_url = "#{@base_url}#{schedule['href']}"
      if !schedule_url.nil? && schedule_url != ""
        puts name
        puts url
        puts schedule_url
        CorePower.get_location_info(name, url, schedule_url)
      end
    end
  end

  def self.get_location_info(name, url, schedule_url)
    puts "name: #{name}, url: #{url}, schedule_url: #{schedule_url}"
    place_id = ProcessLocation.get_place_id(@source, "#{@source}/#{name}")
    if place_id.nil?
      begin
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
        opts[:url] = url
        opts[:category] = Category::Yoga
        opts[:tags] = ["Yoga", "Hot Yoga", "Power Yoga"]
        opts[:schedule_url] = schedule_url

        process_location = ProcessLocation.new(opts)
        place_id = process_location.save_to_database(@source)    
      rescue => e
        puts "ran into issues: #{e}"
        MailerUtils.
        return
      end
    end
    return place_id
  end
end
