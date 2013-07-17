module Api
  module V1
    class CheckinsController < ApplicationController
      
      before_filter :authenticate_user!
      respond_to :json

      def index
        @checkins = current_user.checkins
        render :json => @checkins.as_json(:list => true) 
      end
    end
  end
end
