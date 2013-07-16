require 'spec_helper'

describe Api::V1::PlacesController do

  before(:each) do
    @place = FactoryGirl.create(:place)
    @address = FactoryGirl.create(:valid_address_with_coordinates)
    @place.address_id = @address.id
    @place.save
  end


  describe 'GET #index' do
    it 'returns list of places around you' do
      get :index, lat: 39.110918, lon: -84.515521
      assigns(:places).to_a.should eql([@place])
      response.body.should eql("")
    end
  end

  describe 'GET #show' do
    
    it 'returns a specific place' do
      get :show, id: @place.id
      assigns(:place).should eql(@place)
    end
  end

end
