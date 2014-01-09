class PagesController < ApplicationController

  #before_filter :check_for_mobile
  before_filter :set_tracking_info, :except => [:dummy]

  respond_to :html

  def index
    puts "user agent: #{request.env["HTTP_USER_AGENT"]}" 
    @packages = Package.order(:amount)
  end

  def dummy
    puts "user agent: #{request.env["HTTP_USER_AGENT"]}"
    render :layout => false
  end

  def about
  end

  def plans
  end

  def credits
  end

  def sale
  end

  def locations
  end

  def corporate
  end

  def terms
  end

  def privacy
  end

  def faq
  end

  def promotion
  end

  def android
    redirect_to "https://play.google.com/store/apps/details?id=co.tapfit.android"
  end

  def iphone
    redirect_to "https://itunes.apple.com/us/app/tapfit/id683430709?ls=1&mt=8"
  end


end
