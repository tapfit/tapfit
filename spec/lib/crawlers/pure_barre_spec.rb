require 'spec_helper'

describe PureBarre do

  it 'should get locations for pure barre' do
    # PureBarre.get_locations
  end

  it 'should get locations' do
    # PureBarre.perform(1, true, DateTime.now)
  end

  it 'should get classes for location' do
    place = FactoryGirl.create(:place)
    address = FactoryGirl.create(:valid_address_with_coordinates)
    place.address = address
    place.save
    url = "https://clients.mindbodyonline.com/ASP/home.asp?studioid=14789"
    PureBarre.get_class(url, place.id, DateTime.now)
  end
end
