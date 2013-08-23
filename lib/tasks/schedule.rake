require './lib/crawler'
require './lib/major_cities'
require 'csv'
require './lib/location_crawlers/go_recess_loc'
require './lib/crawlers/moksha'
require './lib/twitter/favorite'
require './lib/twitter/follow'

desc "This task is called by the Heroku scheduler add-on"

task :start_crawl_jobs => :environment do
  puts "Starting crawl process"

  Crawler.start_crawler_process  

  puts "Ending crawl process"
end

task :send_email => :environment do
  MailerUtils.send_error_email
end

task :run_twitter_favorite => :environment do
  Time.zone = "America/New_York"
  if Time.now.hour > 7 && Time.now.hour < 23
    FavoriteTweet.favorite_tweets
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
  FavoriteTweet.clear_favorites
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

task :get_cincy_local => :environment do
  Resque.enqueue(CrawlCincyLocal, DateTime.now, nil)
  Resque.enqueue(CrawlCincyLocal, DateTime.now + 1, nil)
end

task :populate_class_descriptions => :environment do
  Workout.where(:can_buy => true).where("start_time > ?", Time.now).where("source_description IS NOT NULL").each do |workout|
    
  end
end
