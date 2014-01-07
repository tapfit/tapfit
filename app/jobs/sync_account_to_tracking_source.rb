require 'mixpanel-ruby'

class SyncAccountToTrackingSource
  include SuckerPunch::Job

  def perform(opts)

    ActiveRecord::Base.connection_pool.with_connection do
      tracking_code = Tracking.where(:hexicode => opts[:device_token])

      if tracking_code.count > 1
        return
      else
        tracking_code = tracking_code.first
      end

      if !tracking_code.nil?
        tracking_code.update_attributes(:user_id => opts[:user_id])
        $mixpanel.alias(opts[:user_id], tracking_code.distinct_id)
        $mixpanel.track(opts[:user_id], "Registered in app")
      end
    end
  end

end
