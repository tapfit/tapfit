class PhotosController < ApplicationController
  respond_to :json

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
    @photo = Photo.new(params[:photo])
    
    respond_to do |format|
      if @photo.save
        format.html { redirect_to(@photo, :notice => 'Photo successfully created.') }
        format.xml  { render :xml => @photo, :status => :created, :location => @photo }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @photo.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy

  end

  def update

  end
end
