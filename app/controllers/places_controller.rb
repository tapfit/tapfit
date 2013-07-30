require "./lib/crawler_validation/process_location"

class PlacesController < ApplicationController

  before_filter :authenticate_admin!, :only => [ :edit, :create, :update, :new ]

  def index
    @places = Place.paginate(:page => get_page)
  end

  def edit
    @place = Place.find(params[:id])
  end

  def update
    @place = Place.find(params[:id])
    
    respond_to do |format|
      if @place.update_attributes(place_params)
        format.html { redirect_to @place, notice: 'Place was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @place = Place.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @place }
    end
  end

  def new
    @place = Place.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @place }
    end
  end

  def create
    id = ProcessLocation.controller_helper(place_params, address_params, params[:tags], params[:source_id])
    if !id.nil?
      @place = Place.find(id)
    end

    respond_to do |format|
      if !@place.nil?
        format.html { redirect_to(@place, :notice => 'Place successfully created') } 
      else
        format.html { render :action => "new" }
      end
    end  
  end

  private 

  def place_params
    params.require(:place).permit(:name, :url, :phone_number, :source, :source_description, :dropin_price, :schedule_url)
  end

  def address_params
    params.require(:address).permit(:line1, :line2, :city, :state, :zip, :lat, :lon)
  end
end
