web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
resque: env TERM_CHILD=1 RESQUE_TERM_TIMEOUT=30 bundle exec rake resque:work QUEUE=* 
