class Contestant < ActiveRecord::Base

belongs_to :contest
attr_writer :current_step

validates_presence_of :email, :if => lambda { |c| c.current_step == "email" }

def current_step
  @current_step || steps.first
end

def current_step_index
  steps.index(current_step)+1
end

def steps
  %w[email share download]
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

def email_has_downloaded?
  User.exists?(email: self.email)
end

end
