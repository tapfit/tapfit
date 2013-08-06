require './lib/resque_job'
require 'nokogiri'
require './lib/crawler-helpers/healcode'

class Moksha < ResqueJob

  @source = "moksha"

  def self.perform(url, place_id, date)
    if url == 1    
      Moksha.get_locations
      Place.where(:source => @source).each do |place|
        Resque.enqueue(Moksha, place.url, place.id, date)
      end
    else
      Moksha.get_classes(url, place_id, date)
    end
  end

  def self.get_classes(url, place_id, date)
    date = DateTime.parse(date.to_s)
    url = "#{url}classes/schedule/?options[start_date]=#{date.strftime('%Y')}-#{date.strftime('%m')}-#{date.strftime('%d')}"
   
    puts url

    Healcode.get_classes(url, place_id, date, @source)
  end

  def self.get_locations
    response = RestClient.get 'http://www.mokshayoga.ca/scripts/php/studios_ajax_json.php?studios=all'

    parsed_json = JSON.parse(response.to_str)

    Moksha.save_locations_to_database(parsed_json)
  end 

  def self.save_locations_to_database(json)
    json["studios"].each do |gym|

      if ProcessLocation.get_place_id(@source, "#{@source}/#{gym['name']}").nil?

        puts "#{gym['url']}classes/fees/"
        doc = Nokogiri::HTML(open("#{gym['url']}classes/fees/"))

        opts = {}

        els = doc.search("[text()*='Single Class']")
        el = els.first
        if el.nil?
          els = doc.search("[text()*='Drop In']")
          el = els.first
          if el.nil?
            els = doc.search("[text()*='Drop-In']")
            el = els.first
          end
        end

        if !el.nil?
          puts el
          i = 0
          while !el.to_s.include?("<td")
            el = el.parent

            i = i + 1
            puts i
            if i > 3
              break
            end
            # puts el
          end

          puts el

          puts el.next_element.text
          opts[:dropin_price] = el.next_element.text
        end
        address = { :line1 => gym["address"], :city => gym["city"], :state => gym["province"], :zip => gym["postal"], :latitude => gym["lat"], :longitude => gym["lng"] }

        opts[:name] = gym["name"]
        opts[:address] = address
        opts[:tags] = ["Hot Yoga"]
        opts[:phone_number] = gym["phone"]
        opts[:url] = gym["url"]
        opts[:source] = @source
        opts[:category] = Category::Yoga

        process_location = ProcessLocation.new(opts)
        process_location.save_to_database(@source)
      end
    end
  end
end
