
class TrackMobileAppTracking
  include SuckerPunch::Job

  def perform(opts)
    if ENV["ANALYTICS_ENV"] == "production" 

      ActiveRecord::Base.connection_pool.with_connection do 
        tracking = Tracking.where(:distinct_id => opts[:unid]).first
        
        if tracking.nil?

            url = "http://hastrk1.com/serve?action=click&publisher_id=50166&site_id=47168&offer_id=275198&sub_site=#{opts[:utm_source]}&sub_campaign=#{opts[:utm_campaign]}&sub_publisher=#{opts[:utm_medium]}&destination_id=46654&unid=#{opts[:unid]}"
               
            begin 
              RestClient.get(url, opts[:headers] )
            rescue
              
            end

            Tracking.create(:distinct_id => opts[:unid], :utm_source => opts[:utm_source], :utm_campaign => opts[:utm_campaign], :utm_medium => opts[:utm_medium])
        end
      end
    end
  end
end
