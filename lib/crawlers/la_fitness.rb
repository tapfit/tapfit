require './lib/resque_job'
require 'nokogiri'
require 'open-uri'

class LaFitness < ResqueJob

  @source = "lafitness"
  @base_url = "https://www.lafitness.com/Pages/ClubHome.aspx?clubid="

  def self.perform(url, place_id, date)

    if url == 1
      num = 2
      while num < 1015 do
        Resque.enqueue(LaFitness, num, nil, date)
      end
    end

    LaFitness.get_classes(num, date)

  end

  def self.get_classes(num, date)
    return
    place_id = ProcessLocation.get_place_id(@source, num)
    if place_id.nil?
      place_id = LaFitness.get_location_info_and_save(num)
    end 

    if place_id.nil?
      MailerUtils.write_error("Gym ID: #{num}", "couldn't save the gym's info", @source)
    else
      LaFitness.save_classes_to_database(num, place_id)
    end
  end

  def self.get_location_info_and_save(num)
    url = "#{@base_url}#{num}"
    doc = Nokogiri::HTML(open(url))

    content = doc.xpath("//div[@id='mainContent']").first

    opts = {}
    opts[:name] = content.xpath("//td[@class='MainTitle'").first.text
    opts[:city] = content.xpath("//span[@id='ctl00_MainContent_")
    content
  end
end
