class FindTrackingSource
  include SuckerPunch::Job

  def perform(opts)
    ActiveRecord::Base.connection_pool.with_connection do
      tracking_events = Tracking.where("updated_at BETWEEN ? AND ?", DateTime.now - 20.minutes, DateTime.now)     

      if tracking_events.count > 0 
        ip_address_tracking = tracking_events.where(:ip_address => opts[:ip_address]).first
        if !ip_address_tracking.nil?
          ip_address_tracking.update_attribute(:hexicode, opts[:device_token])
          return
        end
        parse_events = tracking_events.where(:download_android => true)
        if parse_events.count == 1
          parse_events.first.update_attribute(:hexicode, opts[:device_token])
        end
      end 
    end
  end

end
