module Api
  module V1
    class PhotosController < ApplicationController
      
      respond_to :json

      def index
        @place = check_place(params[:place_id])
        render :json => @place.photos.as_json
      end

      def show

      end

      def create

      end

      def destroy

      end

      def update

      end

    end
  end
end
