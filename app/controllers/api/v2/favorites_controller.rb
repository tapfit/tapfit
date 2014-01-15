module Api
  module V2
    class FavoritesController < ApplicationController
      
      respond_to :json
      before_filter :check_non_guest

      def index
        @places = current_user.place_favorites
        render :json => { :places => @places.as_json(:list => true) }
      end
      
      def show

      end
    end
  end
end
