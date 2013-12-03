require './lib/braintree/purchase'

module Api
  module V1
    class PackagesController < ApplicationController
       
      respond_to :json

      def index
        @packages = Package.all
        
        render :json => @packages.as_json
      end

      def buy
        json = Purchase.buy_package(current_user, params)

        if json[:success] == false
          render :json => json, :status => 422
        else
          render :json => json
        end
      end 

    end
  end
end
