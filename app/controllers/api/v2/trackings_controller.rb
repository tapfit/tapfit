module Api
  module V2
    class TrackingsController < ApplicationController
      
      def create
        
        FindTrackingSource.new.async.perform({ :device => params[:device], :device_token => params[:device_token], :ip_address => params[:ip_address] }) 

        render :json => [] 
      end

    end
  end
end
