require './lib/crawler'

desc "This task is called by the Heroku scheduler add-on"

task :start_crawl_jobs => :environment do
  puts "Starting crawl process"

  Crawler.start_crawler_process  

  puts "Ending crawl process"
end
