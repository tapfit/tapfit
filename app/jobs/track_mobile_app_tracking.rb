
class TrackMobileAppTracking
  include SuckerPunch::Job

  def perform(opts)

    if ENV["ANALYTICS_ENV"] == "production" 
      url = "http://hastrk1.com/serve?action=click&publisher_id=50166&site_id=47168&offer_id=275198&sub_site=#{opts[:utm_source]}&sub_campaign=#{opts[:utm_campaign]}&sub_publisher=#{opts[:utm_medium]}&destination_id=46654&unid=#{opts[:unid]}"
         
      begin 
        RestClient.get(url)
      rescue
        
      end
    end

  end
end
