require './lib/resque_job'
require 'nokogiri'
require 'open-uri'
Dir["./lib/crawler_validation/*.rb"].each { |file| require file }

class PureBarre < ResqueJob

  @source = "purebarre"
  @base_url = "http://www.purebarre.com/"

  def self.perform(page, location, date)
    
    return
    
    if page == 1
      PureBarre.get_locations
    else
      
    end
  end

  def self.get_locations
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
            # puts content.text.upcase
            array = doc.search('p').first.text.split("\n").map { |f| f.strip }
            array.delete("")
            num = 0
            while num < array.length do
              line = array[num]
              if line.include?("ph")
                puts "phone: #{line.split(" ")[1]}"
                puts "address: #{array[num - 1]}" if num - 1 >= 0
                puts "address: #{array[num - 2]}" if num - 2 >= 0
                puts "address: #{array[num - 3]}" if num - 3 >= 0
                puts "address: #{array[num - 4]}" if num - 4 >= 0
                break
              end
              num = num + 1
            end

          end
        end
      end
    end
  end
end
