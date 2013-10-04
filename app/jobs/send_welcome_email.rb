require 'resque'
require './lib/resque_job'

class SendWelcomeEmail < ResqueJob
  @queue = :email

  def self.perform(user_id)
    user = User.find(user_id)

    user.send_welcome_email
  end

end
