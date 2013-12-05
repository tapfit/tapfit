require './lib/braintree/purchase'

class PackagesController < ApplicationController

  def index
    @packages = Package.all
    render :json => @packages.as_json
  end

  def buy
    json = Purchase.buy_package(current_user, params)
   
    puts json

    if json[:success] == false
        render :oops
    else
        render :confirmation
    end
  end 

  def confirmation
  end

  def oops
  end

end
