require 'spec_helper'

describe Api::V1::PlacesController do

  before(:each) do
    @place = FactoryGirl.create(:place)
    @address = FactoryGirl.create(:valid_address)
    @place.address_id = @address.id
    @place.save
  end


  it 'returns list of places around you' do
    get :index, lat: 39.110918, lon: -84.515521
    response.should be_success
  end

end
