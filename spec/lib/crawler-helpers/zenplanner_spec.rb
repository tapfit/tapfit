require 'spec_helper'

describe Zenplanner do

  it 'should have a class from zenplanner' do
    place = FactoryGirl.create(:place)
    address = FactoryGirl.create(:valid_address_with_coordinates)
    pass_detail = FactoryGirl.build(:pass_detail)
    place_contract = FactoryGirl.build(:place_contract)
    place_contract.discount = 0.50
    place_contract.place_id = place.id
    place_contract.save
    pass_detail.place_id = place.id
    pass_detail.save
    place.address = address
    place.can_buy = true
    place.dropin_price = 15
    place.source = "goRecess"
    place.save
    place.pass_details.first.should_not be_nil

    url = "https://thepunchhouse.sites.zenplanner.com/calendar.cfm"

    Zenplanner.get_classes(url, place.id, DateTime.now + 1.days, place.source)
    
  end

end
