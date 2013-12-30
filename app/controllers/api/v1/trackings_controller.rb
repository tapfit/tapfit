module Api
  module V1
    class TrackingsController < ApplicationController
      
      def create
        puts "params: #{params}"
      end

    end
  end
end
