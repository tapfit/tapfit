class PagesController < ApplicationController

  #before_filter :check_for_mobile
  after_filter :set_tracking_info, only: [ :android, :iphone ]
  before_filter :set_tracking_info, except: [ :android, :iphone ]

  def index
    
    @packages = Package.order(:amount)
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

  def android
    params[:download_android] = true
  end

  def iphone
    params[:download_iphone] = true
    redirect_to "https://itunes.apple.com/us/app/tapfit/id683430709?ls=1&mt=8"
  end

  private

  def set_tracking_info
    if cookies[:distinct_id].nil?
      cookies.permanent[:distinct_id] = SecureRandom.base64
    end

    @distinct_id = cookies[:distinct_id]

=begin
    tracker = Tracking.where(:distinct_id => @distinct_id).first
    if tracker.nil?
      tracker = Tracking.create(:distinct_id => @distinct_id, :utm_source => params[:utm_source], :utm_campaign => params[:utm_campaign], :ip_address => request.remote_ip)
    end
    
    if !params[:download_iphone].nil?
      tracker.update_attribute(:download_iphone, params[:download_iphone])
    end

    if !params[:download_android].nil?
      tracker.update_attribute(:download_android, params[:download_android])
    end

=end
  end
end
