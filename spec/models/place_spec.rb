require 'spec_helper'

describe Place do

  before (:each) do
    @place = FactoryGirl.create(:place) 
    @address = FactoryGirl.create(:valid_address)
    @place.address_id = @address.id
    @place.save 
  end
  
  it 'should return nearby places' do
    places = Place.nearby(39.110918, -84.515521, 0.05)
    places.to_a.should eql([@place])
  end
end
