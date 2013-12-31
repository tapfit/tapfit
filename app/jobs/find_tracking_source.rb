require 'mixpanel-ruby'

class FindTrackingSource
  include SuckerPunch::Job

  def perform(opts)

    return_string = nil
    ActiveRecord::Base.connection_pool.with_connection do

      tracking_events = Tracking.where("updated_at BETWEEN ? AND ?", DateTime.now - 20.minutes, DateTime.now).where(:hexicode => nil)     

      # First check if any tracking events are within that time period
      # We discard the match up if not within 20 min
      if tracking_events.count > 0 

        # First check the ip address to see if they match up
        # We assume if multiple people on same ip, then the one with a "source" is correct
        # Certainty is very high
        ip_address_trackings = tracking_events.where(:ip_address => opts[:ip_address])
        if ip_address_trackings.count > 0
          
          # Find tracking where source is not nil
          # Otherwise choose first
          source_count = ip_address_trackings.select('distinct utm_source').count
          
          if source_count > 1
            return "Failed to match tracking"
          end

          ip_address_with_source = ip_address_trackings.where("utm_source IS NOT NULL").first
          if ip_address_with_source.nil?
            ip_address_with_source = ip_address_trackings.first
          end

          
          ip_address_with_source.update_attribute(:hexicode, opts[:device_token])
          mixpanel_downloaded_app(ip_address_with_source, opts[:device])
          return return_string
        end

        # Next check if device clicked on Download button or visited page directly
        # Once for iPhone
        if opts[:device].upcase == "IPHONE"
          parse_iphone_events = tracking_events.where(:download_iphone => true)
          if parse_iphone_events.count == 1
            tracking_source = parse_iphone_events.first
            tracking_source.update_attribute(:hexicode, opts[:device_token])
            mixpanel_downloaded_app(tracking_source, opts[:device])
            return return_string
          elsif parse_iphone_events.count > 1 && parse_iphone_events.select(:utm_source).distinct.count == 1
            tracking_source = parse_iphone_events.first
            tracking_source.update_attribute(:hexicode, opts[:device_token])
            mixpanel_downloaded_app(tracking_source, opts[:device])
            return return_string
          end   
        # Once for Android
        elsif opts[:device].upcase == "ANDROID"
          parse_android_events = tracking_events.where(:download_android => true)
          if parse_android_events.count == 1
            tracking_source = parse_android_events.first
            tracking_source.update_attribute(:hexicode, opts[:device_token])
            mixpanel_downloaded_app(tracking_source, opts[:device])
            return return_string
          elsif parse_android_events.count > 1 && parse_android_events.select(:utm_source).distinct.count == 1
            tracking_source = parse_android_events.first
            tracking_source.update_attribute(:hexicode, opts[:device_token])
            mixpanel_downloaded_app(tracking_source, opts[:device])
            return return_string
          end   
        end
      end

      return "Failed to match tracking" 
    end
  end

  def mixpanel_downloaded_app(tracking_record, device_string)
    $mixpanel.track(tracking_record.user_id, "Downloaded app", {
      'Type' => device_string
    })  
  end

end
