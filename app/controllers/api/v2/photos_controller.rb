module Api
  module V2
    class PhotosController < ApplicationController
      
      respond_to :json

      def index
        @place = check_place(params[:place_id])
        if @place.instance_of?(Place)
          @photos = @place.photos
          render :json => @photos.as_json
        end
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
