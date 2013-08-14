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
    places = Place.nearby(39.110918, -84.515521, 0.05, nil)
    places.to_a.should eql([@place])
  end

  it 'should return the correct nearby places' do
    places = Place.get_nearby_places(39.110918, -84.515521, 100, nil)
    places.to_a.should eql([@place])
  end



  it 'should return todays workouts' do
    @place.todays_workouts
  end

  it 'should return nearby places wth default' do
    places = Place.get_nearby_places(nil, nil, nil, nil)
    places.to_a.should eql([@place])
  end

  it 'should return nearby places with string input' do
    places = Place.get_nearby_places(39.110918, -84.515521, 100, nil)
    places.to_a.should eql([@place])
  end

  it 'should return class times' do
    workout = FactoryGirl.create(:workout)
    @place.workouts << workout
    workout2 = FactoryGirl.create(:workout)
    workout2.start_time = workout2.start_time.advance(:hours => 1)
    @place.workouts << workout2
    @place.save
    @place.class_times.should eql("11a 12p")
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

  it 'should return photo for a place' do
    @photo = FactoryGirl.create(:photo)
    @place.icon_photo_id = @photo.id
    @place.save
    @place.icon_photo.should eql("#{Photo.image_base_url}/images/icon/#{@photo.id}.jpg")
  end

  it 'should not return a workout if past' do
    workout = FactoryGirl.create(:workout)
    workout.start_time = Time.now - 24.days
    workout.save
    @place.workouts << workout
    @place.save
    puts Time.zone.now
    @place.todays_workouts.count.should eql(0)
  end

  it 'should keep category tags' do
    @place.category_list.add("my_man")
    @place.save
    @place.category_list.should eql(["My Man"])
    @place.name = "Fuck tard"
    @place.save
    @place.category_list.should eql(["My Man"])
  end

  it 'should return -1 if no ratings' do
    @place.avg_rating.should eql(-1)
  end

  it 'should return an avg rating for a place' do
    rating = FactoryGirl.build(:rating)
    rating.place_id = @place.id
    rating1 = FactoryGirl.build(:rating)
    rating1.place_id = @place.id
    rating1.rating = 4
    rating.save
    rating1.save

    @place.ratings << rating
    @place.ratings << rating1

    @place.avg_rating.should eql(4.5)
  end

  it 'should return reviews for only non-nil reviews' do
    rating = FactoryGirl.build(:rating)
    rating.place_id = @place.id
    rating.save
    rating1 = FactoryGirl.build(:rating)
    rating1.place_id = @place.id
    rating1.review = nil
    rating1.save

    @place.ratings << rating
    @place.ratings << rating1

    @place.reviews.count.should eql(1)
  end

  it 'should return search results' do
    @place.category_list.add("yoga")
    @place.category = "Kit Kat"
    @place.save

    Place.get_nearby_places(45, -88, 3000, "yoga").should eql([@place])

    Place.get_nearby_places(45, -88, 3000, "string").should eql([@place])

    Place.get_nearby_places(45, -88, 3000, "kat").should eql([@place])

    Place.get_nearby_places(45, -88, 3000, "kjasdlfkj").should eql([])
  end

end
