require 'spec_helper'

describe Api::V1::PhotosController do
  
  before(:each) do
    @place = FactoryGirl.create(:place)
    @photo = FactoryGirl.create(:photo)
    @place.cover_photo_id = @photo.id
    @place.photos << @photo
    @place.save
  end

  it 'should return photos for valid place' do
    get :index, place_id: @place.id
    assigns(:photos).to_a.should eql([@photo])
  end

  it 'should not return anything for invalid place' do
    get :index, place_id: -1
    response.body.should include("errors")
  end
end
