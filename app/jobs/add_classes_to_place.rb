require 'resque'
require './lib/resque_job'
require './lib/crawler_source'

class AddClassesToPlace < ResqueJob

  @queue = :add_class

  def self.perform(place_id)
    place = Place.find(place_id)
    if place.crawler_source == CrawlerSource::Mindbody
      CasperMindbody.get_classes(place.schedule_url, place.id, DateTime.now, place.source) 
      CasperMindbody.get_classes(place.schedule_url, place.id, DateTime.now + 1.days, place.source)
    elsif place.crawler_source == CrawlerSource::Healcode
      Healcode.get_classes(place.schedule_url, place.id, DateTime.now, place.source)
      Healcode.get_classes(place.schedule_url, place.id, DateTime.now + 1.days, place.source)
    elsif
      Zenplanner.get_classes(place.schedule_url, place.id, DateTime.now, place.source)
      Zenplanner.get_classes(place.schedule_url, place.id, DateTime.now + 1.days, place.source)
    elsif place.crawler_source == CrawlerSource::GoRecess
      if place.workouts.where("start_time > ?", DateTime.now + 2.days).count < 1
        GoRecess.get_classes(place.schedule_url, place.id, date)
      end
    end
    

    if place.facility_type == FacilityType::DayPassWithClass || place.facility_type == FacilityType::DayPassNoClass
      place.place_hours.each do |hour|
        DayPass.create_day_pass(place, hour, DateTime.now)
        DayPass.create_day_pass(place, hour, DateTime.now + 1.days)
      end
    end 
  end

end
