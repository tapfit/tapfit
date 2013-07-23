require './lib/crawler'
require './lib/major_cities'
require 'csv'
require './lib/location_crawlers/go_recess_loc'

desc "This task is called by the Heroku scheduler add-on"

task :start_crawl_jobs => :environment do
  puts "Starting crawl process"

  Crawler.start_crawler_process  

  puts "Ending crawl process"
end

task :send_email => :environment do
  MailerUtils.send_error_email
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

task :get_la_fitness_locations do
  Resque.enqueue(LaFitness, 1, true, DateTime.now)
end

task :get_moksha_locations do
  Resque.enqueue(Moksha, 1, 3, DateTime.now)
end

task :get_go_recess => :environment do
  Resque.enqueue(GoRecess, 1, true, DateTime.now) 
end

task :get_go_recess_locations => :environment do
  Resque.enqueue(GoRecessLoc, 1, true, nil, nil)
end

task :list_lat_lon => :environment do
  
  new_string = LatLon.get_lat_lon.gsub("{", "")
  new_string = new_string.gsub(",", "")
  new_string = new_string.gsub(":", "")
  new_string = new_string.gsub("}", "")
  new_string = new_string.gsub("'", '"')

  new_string.each_line do |line|
    string = ""
    line = line.split(" ")
    if line[4] == '"latitude"'
      string = string + "lat: #{line[5]}"
    else
      i = 5
      while i < line.length do
        if line[i] == '"latitude"'
          string = string + "lat: #{line[i + 1]}"
          break
        else
          i += 1
        end
      end 
    end

    if line[6] == '"longitude"'
      string = string + ", lon: #{line[7]}"
    else
      i = 7
      while i < line.length do
        if line[i] == '"longitude"'
          string = string + ", lon: #{line[i + 1]}"
          break
        else
          i += 1
        end
      end
    end

    puts string
  end 

end
