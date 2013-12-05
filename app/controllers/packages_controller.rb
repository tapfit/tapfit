require './lib/braintree/purchase'

class PackagesController < ApplicationController

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

  def confirmation
    @package = Package.find(params[:package_id])


  end
end
