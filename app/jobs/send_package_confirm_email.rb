
require 'resque'
require './lib/resque_job'

class SendPackageConfirmEmail < ResqueJob

  @queue = :email

  def self.perform(email, package_id)
    
    # Send email with package id info

  end

end

