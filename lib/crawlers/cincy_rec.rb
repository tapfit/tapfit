require 'nokogiri'
require 'open-uri'
require './lib/resque_job'
require './lib/crawler'

class CincyRec < ResqueJob

  @source = "cincyrec"
  @base_url = "http://cincyrec.org/search/facility.aspx?id="

  def self.perform(page, arg, arg1)
    if page == 1
      num = 2
      while num < 2500 do
        Resque.enqueue(CincyRec, num, true, DateTime.now)
        num = num + 1
      end
    end

    CincyRec.get_place(page)
  end

  def self.get_place(num)

    if ProcessLocation.get_place_id(@source, num).nil?
      url = "#{@base_url}#{num}"
      doc = Nokogiri::HTML(open(url))

      name = doc.xpath("//span[@id='lblFacilityName']").first
      amenities = doc.xpath("//span[@id='lblAmenities']").first
      cost = doc.xpath("//span[@id='lblUsageCost']").first
      description = doc.xpath("//span[@id='lblDescription']").first

      
      if name.nil? 
        return
      elsif !description.nil? && description.text.upcase.include?("CLOSED")
        return        
      else
        name = ( !name.nil? ? name.text : "" )
        cost = ( !cost.nil? ? cost.text : "" ) 
        amenities = ( !amenities.nil? ? amenities.text : "" )
        description = ( !description.nil? ? description.text : "" )

        category = CincyRec.get_facility_category(name, amenities)
        if category.nil?
          return
        end
        
        loc = doc.xpath("//span[@id='lblAddress']").first
        phone = doc.xpath("//span[@id='lblPhoneNumber']").first

        # loc = loc.text.split("<br>")
        puts "id: #{num}, pre-split address: #{loc.content}"
        loc = loc.content.gsub(/(?<=[a-z])(?=[A-Z])/, '%').split('%')
        if loc.length < 2
          loc = loc.split(".")
          if loc.length < 2
            return
          end
        end
        puts "id: #{num}, address: #{loc}"
        address = {}
        address[:line1] = loc[0]
        address = Crawler.separate_city_state_zip(address, loc[1])

        puts address

        opts = {}
        opts[:name] = name
        opts[:address] = address
        opts[:phone_number] = phone.text
        opts[:category] = category
        opts[:source] = @source
        opts[:source_id] = num
        opts[:url] = url
        opts[:source_description] = description if !description.upcase.include?("CLOSED")
        opts[:tags] = amenities.split("-").collect(&:strip)

        process_location = ProcessLocation.new(opts)
        process_location.save_to_database(@source)
        # File.open("cincyrec.txt", "a+") {|f| f << "\nPage with id: #{num}, facility name: #{name}, cost: #{cost}, amenities: #{amenities}" }
      end
    end
  end

  def self.get_facility_category(name, amenities)

    name_upcase = "#{name.upcase} #{amenities.upcase}"
    if name_upcase.include?("POOL")
      return Category::Aquatics
    elsif name_upcase.include?("BASEBALL") || name_upcase.include?("SOFTBALL")
      return Category::Baseball
    elsif name_upcase.include?("FOOTBALL")
      return Category::Football
    elsif name_upcase.include?("SOCCER")
      return Category::Soccer
    elsif name_upcase.include?("TENNIS")
      return Category::Tennis
    elsif name_upcase.include?("GOLF")
      return Category::Golf
    else
      return nil
    end
  end 

end
