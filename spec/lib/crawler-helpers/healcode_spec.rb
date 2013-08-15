require 'spec_helper'

describe Healcode do

  it 'should parse healcode site' do
    place = FactoryGirl.create(:place)
    address = FactoryGirl.create(:valid_address_with_coordinates)
    place.address = address
    place.save
    url = "http://cincinnati.mokshayoga.ca/classes/schedule/"
    Healcode.get_classes(url, place.id, DateTime.now, "test")
  end

end
