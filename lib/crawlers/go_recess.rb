require './lib/resque_job'

class GoRecess < ResqueJob
  
  def self.perform(rerun)
    if rerun 
      Resque.enqueue(GoRecess, false)
    end
  end  
end
