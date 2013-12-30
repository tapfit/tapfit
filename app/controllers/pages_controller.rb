class PagesController < ApplicationController

  #before_filter :check_for_mobile

  def index
    if cookies[:distinct_id].nil?
      cookies.permanent[:distinct_id] = SecureRandom.base64
    end

    @distinct_id = cookies[:distinct_id]

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
end
