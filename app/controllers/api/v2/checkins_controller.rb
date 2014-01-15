module Api
  module V2
    class CheckinsController < ApplicationController
      
      before_filter :check_non_guest
      respond_to :json

      def index
        @checkins = current_user.checkins
        render :json => @checkins.as_json(:list => true) 
      end
    end
  end
end
