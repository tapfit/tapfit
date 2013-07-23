require 'spec_helper'

describe LaFitness do

  it 'should save a location to a database' do
    place_id = LaFitness.get_location_info_and_save(995)
    #place = Place.find(place_id).category_list.should eql(nil)
    Place.find(place_id).should_not raise_error
  end

  it 'should save a class to the database' do
    LaFitness.save_classes_to_database(995, 1, DateTime.now)
  end

end
