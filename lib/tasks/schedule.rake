require './lib/crawler'
require './lib/major_cities'
require 'csv'
require './lib/location_crawlers/go_recess_loc'
require './lib/crawlers/moksha'
require './lib/twitter/favorite'
require './lib/twitter/follow'
require './lib/crawler-helpers/mindbody'
require './lib/crawler-helpers/casper_mindbody'

desc "This task is called by the Heroku scheduler add-on"


task :get_tapfit_stats => :environment do

  date = Date.today.beginning_of_week

  while date > Date.parse('2013-08-01')
    # puts date
    receipt_total = Receipt.where("created_at >= ?", date).where("created_at <= ?", date + 1.week).sum('price')
    package_total = Credit.joins(:package).where("package_id IS NOT NULL").where("credits.created_at >= ?", date).where("credits.created_at <= ?", date + 1.week).sum('packages.amount')

    puts receipt_total + package_total
    date = date - 1.week
  end

end

task :get_user_stats => :environment do

  $stdout = File.new('./user_stats.csv', 'w')

  puts "First Name, Last Name, Email, Location, Sign In Count, Total Passes, Total Packages"

  User.all.each do |user|
    puts "#{user.first_name}, #{user.last_name}, #{user.email}, \"#{user.location}\", #{user.sign_in_count}, #{user.receipts.count}, #{user.credits.joins(:package).where("package_id IS NOT NULL").count}"
  end
end


task :start_crawl_jobs => :environment do
  puts "Starting crawl process"

  Crawler.start_crawler_process  

  puts "Ending crawl process"
end

task :test_casper => :environment do
 
  url = "https://clients.mindbodyonline.com/ASP/home.asp?studioid=30154" 
  CasperMindbody.get_classes(url, 5, DateTime.now, "source")

end

task :get_zenplanner_jobs => :environment do

  Place.where(:can_buy => true).where(:source => "zenplanner").each do |place|
    Zenplanner.get_classes(place.schedule_url, place.id, DateTime.now, place.source)
    Zenplanner.get_classes(place.schedule_url, place.id, DateTime.now + 1.days, place.source)
  end

end

task :send_email => :environment do
  MailerUtils.send_error_email
end

task :update_place_contracts => :environment do
  Place.where(:can_buy => true).each do |place|
    if place.place_contract.nil?
      place_contract = PlaceContract.create(:discount => 0.20, :quantity => 100, :place_id => place.id)
      place.workouts.where("start_time > ?", Time.now).where("price IS NOT NULL").each do |workout|
        if workout.original_price.nil?
          workout.original_price = workout.price
        end
        
        workout.price = ((1 - place_contract.discount) * workout.original_price).round
        workout.save
      end
      workout = place.todays_workouts.order("price ASC").first
      if !workout.nil?
        place.lowest_price = workout.price
        place.lowest_original_price = workout.original_price
        place.save
      end 
    end
  end
end

task :scrape_core_movement => :environment do
  place = Place.find(13)
  CasperMindbody.get_classes(place.schedule_url, place.id, DateTime.now + 1.days, place.source)
end

task :add_day_pass => :environment do
  Place.where(:can_buy => true).each do |place|
    if place.facility_type == 1 || place.facility_type == 2
      place.place_hours.each do |hour|
        DayPass.create_day_pass(place, hour, DateTime.now)
        DayPass.create_day_pass(place, hour, DateTime.now + 1.days)
      end
    end
  end
end

task :run_twitter_favorite => :environment do
  
  FavoriteTweet.favorite_tweets
  Time.zone = "America/New_York"
  if Time.now.hour > 7 && Time.now.hour < 23
    # FavoriteTweet.favorite_tweets
  end
end

task :run_twitter_follow => :environment do
  
  Time.zone = "America/New_York"
  days_of_week = [ 1, 3, 4, 6 ]
  if days_of_week.include?(Time.now.wday)
    if Time.now.hour > 9 && Time.now.hour < 19
      Follow.follow
    end
  end
end

task :run_twitter_unfollow => :environment do
  Time.zone = "America/New_York"
  days_of_week = [ 0, 2, 5 ]
  if days_of_week.include?(Time.now.wday)
    Follow.unfollow
  end
end

task :run_twitter_get_followers => :environment do
  GetFollowers.get_followers
  #FavoriteTweet.clear_favorites
end

task :rerun_crawl_jobs => :environment do
  
  if REDIS.exists(MailerUtils.redis_key)
    puts "MailerUtils.redis_key exists"
    if !REDIS.exists(MailerUtils.redis_key + "sent")
      puts "About to send email"
      MailerUtils.send_error_email
      REDIS.set(MailerUtils.redis_key + "sent", true)
    end
  else
    puts "MailerUtils.redis_key does not exist, running crawler process"
    Crawler.start_crawler_process
  end

end

task :update_go_recess_locations => :environment do
  Resque.enqueue(GoRecess, 1, true, DateTime.now)
end

task :update_go_recess_boulder => :environment do
  GoRecess.get_locations(1, DateTime.now, {:lat => 40.014986, :lon => -105.270546 } )
end

task :get_cincy_local => :environment do
  Resque.enqueue(CrawlCincyLocal, DateTime.now, nil)
  Resque.enqueue(CrawlCincyLocal, DateTime.now + 1, nil)
end

task :populate_class_descriptions => :environment do
  Workout.where(:can_buy => true).where("start_time > ?", Time.now).where("source_description IS NOT NULL").each do |workout|
    
  end
end
