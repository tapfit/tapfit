Dir["./lib/crawler-helpers/*.rb"].each { |file| require file }
require './lib/resque_job'
require './lib/crawler_source'

class CrawlCincyLocal < ResqueJob

  def self.perform(date, place_id)

    if place_id.nil?
      Place.where(:can_buy => true).each do |place|
        Resque.enqueue(self, date, place.id)
      end
    else
      place = Place.find(place_id)
      date = DateTime.parse(date.to_s)
      if place.crawler_source == CrawlerSource::Mindbody
        Mindbody.get_classes(place.schedule_url, place.id, date, place.source) 
      elsif place.crawler_source == CrawlerSource::Healcode
        Healcode.get_classes(place.schedule_url, place.id, date, place.source)
      elsif place.crawler_source == CrawlerSource::GoRecess
        if place.workouts.where("start_time > ?", DateTime.now + 2.days).count < 1
          GoRecess.get_classes(place.schedule_url, place.id, date)
        end
      end
    end

  end

end
