Dir["./lib/crawlers/*.rb"].each {|file| require file }

module Crawler
  
  def self.start_crawler_process
    Resque.enqueue(CrawlCincyLocal, DateTime.now, nil)
    Resque.enqueue(CrawlCincyLocal, DateTime.now + 1.days, nil)
    Dir.glob("./lib/crawlers/*.rb").each do |file|
      File.open(file).each_line do |line|
        if line.include?("class")
          # Resque.enqueue(Kernel.const_get(line.split(" ")[1]), 1, true, DateTime.now)
          # Resque.enqueue(Kernel.const_get(line.split(" ")[1]), 1, true, DateTime.now + 1.days)
          break
        end
      end
    end
  end

  def self.separate_city_state_zip(address = {}, line)
    city_state = line.split(",")
    if city_state.length > 1
      address[:city] = city_state[0]
      state_zip = city_state[1].split(" ")
      address[:zip] = state_zip.delete_at(state_zip.length - 1)
      address[:state] = state_zip.join(" ")
    else
      city_state = line.split(" ")
      address[:zip] = city_state.delete_at(city_state.length - 1)
      address[:state] = city_state.delete_at(city_state.length - 1)
      address[:city] = city_state.join(" ")
    end
    return address  
  end

  def self.update_classes
    Place.all.each do |place|
      if place.can_buy == true
        place.workouts.update_all(:can_buy => true)
      else
        place.workouts.update_all(:can_buy => false)
      end
    end
  end

end
