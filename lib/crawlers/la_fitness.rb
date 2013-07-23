require './lib/resque_job'
require 'nokogiri'
require 'open-uri'

class LaFitness < ResqueJob

  @source = "lafitness"
  @base_url = "https://www.lafitness.com/Pages/ClubHome.aspx?clubid="
  @base_schedule_url = "https://www.lafitness.com/Pages/ClassSchedulePrintVersion.aspx?clubid="

  def self.perform(url, place_id, date)

    if url == 1
      num = 2
      while num < 1015 do
        Resque.enqueue(LaFitness, num, nil, date)
        num = num + 1
      end
    end

    LaFitness.get_classes(url, date)

  end

  def self.get_classes(num, date)
    place_id = ProcessLocation.get_place_id(@source, num)
    if place_id.nil?
      place_id = LaFitness.get_location_info_and_save(num)
    end 

    if place_id.nil?
      MailerUtils.write_error("Gym ID: #{num}", "couldn't save the gym's info", @source)
    else
      LaFitness.save_classes_to_database(num, place_id, date)
    end
  end

  def self.save_classes_to_database(num, place_id, date)
    url = "#{@base_schedule_url}#{num}"
    doc = Nokogiri::HTML(open(url))

    date = Time.parse(date.to_s)
    column = date.wday + 1
    headers = doc.xpath("//th[@class='tableDataHeader']")
    rows = doc.xpath("//table[@id='tblSchedule']/tr")

    rows.each do |row|
      data = row.children

      if data[column].children.count > 1
        start_time = data[0].text.strip
        name = data[column].children[1].children[0].text
        teacher = data[column].children[3].text
        
        opts = {}
        opts[:place_id] = place_id
        opts[:name] = name
        starts = Time.parse(start_time)
        opts[:start_time] = date.beginning_of_day.advance(:hours => starts.strftime("%H").to_i, :minutes => starts.strftime("%M").to_i)
        opts[:end_time] = date.beginning_of_day.advance(:hours => (starts.strftime("%H").to_i + 1), :minutes => starts.strftime("%M").to_i)
        opts[:source] = @source
        opts[:instructor] = teacher

        process_class = ProcessClass.new(opts)
        process_class.save_to_database(@source)

      end
    end

  end

  def self.get_location_info_and_save(num)
    url = "#{@base_url}#{num}"
    doc = Nokogiri::HTML(open(url))

    puts url
    # puts doc

    content = doc.xpath("//div[@id='mainContent']").first

    # Run through amenities and add them as tags
    tags = []
    i = 1
    while i < 9 do
      img = content.xpath("//img[@id='ctl00_MainContent_clubAmenity_Image#{i}']/@src")
      if !img.nil?
        puts img
        image_source = img.to_s.split('/')
        if !image_source[2].nil? && image_source[2] != "BW"
          tags << image_source[2].gsub(/(?<=[a-z])(?=[A-Z])/, ' ').split('.')[0]
        end
      end
      i = i + 1
    end

    address = {}
    line1 = content.xpath("//span[@id='ctl00_MainContent_lblClubAddress']").first
    if line1.nil?
      puts "Redirected"
      return
    end
    address[:line1] = content.xpath("//span[@id='ctl00_MainContent_lblClubAddress']").first.text
    address[:city] = content.xpath("//span[@id='ctl00_MainContent_lblClubCity']").first.text
    address[:state] = content.xpath("//span[@id='ctl00_MainContent_lblClubState']").first.text
    address[:zip] = content.xpath("//span[@id='ctl00_MainContent_lblZipCode']").first.text

    opts = {}
    opts[:name] = "LA Fitness - #{content.xpath("//td[@class='MainTitle']").first.text.gsub(/[\n\t\r]/, "").strip}"
    opts[:tags] = tags
    opts[:phone_number] = content.xpath("//span[@id='ctl00_MainContent_lblClubPhone']").first.text[0, 14]
    opts[:url] = url
    opts[:schedule_url] = "#{@base_schedule_url}#{num}"
    opts[:source] = @source
    opts[:address] = address
    opts[:source_id] = num
    opts[:category] = Category::Gym

    process_location = ProcessLocation.new(opts)
    return process_location.save_to_database(@source)
  end

end
