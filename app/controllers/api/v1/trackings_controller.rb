module Api
  module V1
    class TrackingsController < ApplicationController
      
      def create
        puts "params: #{params}"

        render :json => [] 
      end

    end
  end
end
