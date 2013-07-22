require 'spec_helper'

describe Place do

  before (:each) do
    @place = FactoryGirl.create(:place) 
    @address = FactoryGirl.create(:valid_address_with_coordinates)
    @place.address_id = @address.id
    @place.save 
    @image_url = 'http://cdn04.cdn.justjaredjr.com/wp-content/uploads/headlines/2013/06/miley-cyrus-chanel-selfies-in-miami.jpg'
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
    @place.next_class[:id].should eql(workout.as_json(:place => true)[:id])
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

  it 'should return nil if no photo' do
    @place.cover_photo.should be_nil
  end

  it 'should not return a workout if past' do
    workout = FactoryGirl.create(:workout)
    workout.start_time = Time.now - 5.hours
    workout.save
    @place.workouts << workout
    @place.save
    @place.get_workouts.count.should eql(0)
  end

  it 'should keep category tags' do
    @place.category_list.add("my_man")
    @place.save
    @place.category_list.should eql(["My Man"])
    @place.name = "Fuck tard"
    @place.save
    @place.category_list.should eql(["My Man"])
  end
end
