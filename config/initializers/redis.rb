REDIS = Redis.connect(:url => ENV["OPENREDIS_URL"])
Resque.redis = REDIS
