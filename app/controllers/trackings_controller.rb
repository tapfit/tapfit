class TrackingsController < ApplicationController
  
  def create
    puts "create tracking entry"
    puts "params: #{tracking_params}"
    Tracking.create(tracking_params)
  end  
 
  private 

  def tracking_params
    params.require(:tracking).permit(:distinct_id, :utm_medium, :utm_source, :utm_campaign, :utm_content, :download_iphone, :download_android)
  end 
  
  
end
