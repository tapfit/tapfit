require 'spec_helper'

describe LaFitness do

  it 'should save a location to a database' do
    num = 399
    while num < 401 do
      place_id = LaFitness.get_location_info_and_save(num)
      #place = Place.find(place_id).category_list.should eql(nil)
      #Place.find(place_id).should_not raise_error
      num = num + 1
    end
    REDIS.lpop(MailerUtils.redis_key).should eql("")
  end

  it 'should save a class to the database' do
    place = FactoryGirl.create(:place)
    address = FactoryGirl.create(:valid_address_with_coordinates)
    place.address = address
    place.save
    LaFitness.save_classes_to_database(995, place.id, DateTime.now)
  end

end
