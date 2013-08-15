require 'spec_helper'

describe Mindbody do


  it 'should save a class from mindbody' do
    place = FactoryGirl.create(:place)
    address = FactoryGirl.create(:valid_address_with_coordinates)
    place.address = address
    place.save
    url = "http://clients.mindbodyonline.com/ws.asp?studioid=2455&amp;stype=-7&amp;sView=week&amp;sLoc=2"
    Mindbody.get_classes(url, place.id, DateTime.now, "test")
  end

end
