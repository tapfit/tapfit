require 'mixpanel-ruby'

class SyncAccountToTrackingSource
  include SuckerPunch::Job

  def perform(opts)

    tracker = Mixpanel::Tracker.new("8da0869d7ee062dfed009dc9fb6d2b27")

    ActiveRecord::Base.connection_pool.with_connection do
      tracking_code = Tracking.where(:hexicode => opts[:device_token]).first

      if !tracking_code.nil?
        tracking_code.update_attributes(:user_id => opts[:user_id])
        tracker.alias(opts[:user_id], tracking_code.distinct_id)
      end
    end
  end

end
