class Contestant < ActiveRecord::Base

belongs_to :contest
attr_writer :current_step

validates_presence_of :email, :if => lambda { |c| c.current_step == "email" }
validates_presence_of :has_downloaded, :if => lambda { |c| c.current_step == "download" }

def current_step
  @current_step || steps.first
end

def steps
  %w[email download share]
end

def next_step
  self.current_step = steps[steps.index(current_step)+1]
end

def previous_step
  self.current_step = steps[steps.index(current_step)-1]
end

def first_step?
  current_step == steps.first
end

def last_step?
  current_step == steps.last
end

def all_valid?
  steps.all? do |step|
    self.current_step = step
    valid?
  end
end

end
