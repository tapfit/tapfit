module Api
  module V2
    class RegionsController < ApplicationController
      
      respond_to :json

      def index
        @regions = Region.all
        render :json => @regions.as_json
      end

    end
  end
end
