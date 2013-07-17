class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  def check_place(place_id)
    @place = Place.where(:id => place_id).first
    if @place.nil?
      render :json => { :code => 2, :message => "Could not find place with id: #{place_id}" }
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
end
