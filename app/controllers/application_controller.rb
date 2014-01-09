class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  def check_non_guest
    authenticate_user!
    if current_user.is_guest
      render :json => { :error => "User needs to register" } and return
    end
  end

  def check_place(place_id)
    @place = Place.where(:id => place_id).first
    if @place.nil?
      render :json => { :errors => "Could not find place with id: #{place_id}" }, :status => 422 and return
    else
      return @place
    end
  end

  def get_page
    if params[:page].nil?
      return 1
    else
      return params[:page]
    end
  end

  def authenticate_admin!
    authenticate_user!
    unless current_user.instance_of?(AdminUser)
      flash[:alert] = "Unauthorized access"
      redirect_to root_path
    end 
  end

  def check_for_mobile
    session[:mobile_override] = params[:mobile] if params[:mobile]
    prepare_for_mobile if mobile_device?
  end

  def prepare_for_mobile
    prepend_view_path Rails.root + 'app' + 'views_mobile'
  end

  def set_tracking_info
    if request.env['HTTP_USER_AGENT'].include?("Ruby")
      puts "Ruby user agent"
      return
    end

    TrackMobileAppTracking.new.async.perform(get_source_info)
  end

  def get_source_info
   
    if cookies.signed[:distinct_id].nil?
      cookies.permanent.signed[:distinct_id] = { :value => SecureRandom.base64, :domain => ".tapfit.co" }
    end

    @distinct_id = cookies.signed[:distinct_id]

    source = params[:utm_source]
    if source.nil?
      source = request.referer
    end

    opts = {}
    opts[:utm_source] = source
    opts[:utm_campaign] = params[:utm_campaign]
    opts[:utm_medium] = params[:utm_medium]
    opts[:unid] = @distinct_id
    return opts
  end

  def mobile_device?
    if session[:mobile_override]
      session[:mobile_override] == "1"
    else
      (request.user_agent =~ /Mobile|webOS/) && (request.user_agent !~ /iPad/)
    end
  end

helper_method :mobile_device?

end
