require 'resque/tasks'

task "resque:setup" => :environment do
  ENV['QUEUE'] = '*'
  ActiveRecord::Base.descendants.each { |klass|  klass.columns }
end

desc "Alias for resque:work (To run workers on Heroku)"
task "jobs:work" => "resque:work"
