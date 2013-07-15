require 'spec_helper'

describe Place do

  before (:each) do
    @place = FactoryGirl.create(:place) 
    @address = FactoryGirl.create(:valid_address_with_coordinates)
    @place.address_id = @address.id
    @place.save 
  end
  
  it 'should return nearby places' do
    places = Place.nearby(39.110918, -84.515521, 0.05)
    places.to_a.should eql([@place])
  end

  it 'should return the correct nearby places' do
    places = Place.get_nearby_places(39.110918, -84.515521)
    places.to_a.should eql([@place])
  end

  it 'should return nearby places with string input' do
    places = Place.get_nearby_places(39.110918, -84.515521)
    places.to_a.should eql([@place])
  end

  it 'should return next class' do
    workout = FactoryGirl.create(:workout)
    @place.workouts << workout
    @place.save
    @place.next_class.should eql(workout.as_json(:place => true))
  end

  it 'should update tags to what we want' do
    @place.category_list.add("yoga")
    @place.category_list.add("fun_times")
    @place.save
    @place.category_list[0].should eql("Yoga")
    @place.category_list[1].should eql("Fun Times")
  end

  it 'should return categories' do
    @place.category_list.add("yoga")
    @place.save
    # @place.as_json(:list => true).should eql("")
  end
end
