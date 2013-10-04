Dir["/lib/crawlers/*.rb"].each { |file| require file }
Dir["/lib/location_crawlers/*.rb"].each { |file| require file }
Dir["/app/jobs/*.rb"].each { |file| require file }
