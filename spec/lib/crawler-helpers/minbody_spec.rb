require 'spec_helper'

describe Mindbody do


  it 'should save a class from mindbody' do
    place = FactoryGirl.create(:place)
    address = FactoryGirl.create(:valid_address_with_coordinates)
    place.address = address
    place.save
    url = "https://clients.mindbodyonline.com/ASP/home.asp?studioid=30298"
    Mindbody.get_classes(url, place.id, DateTime.now, "test")
  end

end
