class PhotosController < ApplicationController
  respond_to :json

  before_filter :authenticate_admin!, :only => [:new, :create]

  def index
    @place = check_place(params[:place_id])
    render :json => @place.photos.as_json
  end

  # GET /photos/new
  # GET /photos/new.xml
  def new
    @photo = Photo.new
    @place = Place.find(params[:place_id]) 
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @photo }
    end
  end

  def show
    @photo = Photo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @photo }
    end
  end

  def create
    @photo = Photo.new(photo_params)
   
    puts @photo 
    respond_to do |format|
      if @photo.save
        @place = check_place(params[:place_id])
        @place.photos << @photo
        @place.icon_photo_id = @photo.id if params[:icon_photo] == "1"
        @place.cover_photo_id = @photo.id if params[:cover_photo] == "1"
        @place.save 
        format.html { redirect_to admin_place_path(@place) }
        format.xml  { render :xml => @photo, :status => :created, :location => @photo }
      else
        format.html { redirect_to admin_place_path(@place) }
        format.xml  { render :xml => @photo.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy

  end

  def update

  end

  private

  def photo_params
    params.require(:photo).permit(:user_id, :place_id, :image, :workout_key, :url)
  end
end
