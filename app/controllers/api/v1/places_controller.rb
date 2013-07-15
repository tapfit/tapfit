module Api
  module V1
    class PlacesController < ApplicationController
      
      respond_to :json

      # GET places/
      # Params: lat, lon. Optional Params: auth_token, q, radius
      # Returns array of place around you (default: cincinnati)
      def index
        @places = Place.get_nearby_places(params[:lat], params[:lon])
        render @places.as_json
      end
      
      def show

      end

      def create

      end

      def update

      end

      def destroy

      end

    end
  end
end
