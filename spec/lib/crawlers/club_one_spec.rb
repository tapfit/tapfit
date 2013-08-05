require 'spec_helper'

describe ClubOne do

  it 'should get locations for club one' do
    # ClubOne.get_locations(DateTime.now)
  end

  it 'should get classes for club one' do
    place = FactoryGirl.create(:place)
    address = FactoryGirl.create(:valid_address_with_coordinates)
    place.address = address
    place.save
    url = "http://www.clubone.com/Classes?club=Citigroup-Center"
    ClubOne.get_classes(url, place.id, DateTime.now + 1.days) 
  end  

end
