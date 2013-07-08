require './lib/resque_job'

class GoRecess < ResqueJob
  
  def self.perform
    puts "running GoRecess"
  end  
end
