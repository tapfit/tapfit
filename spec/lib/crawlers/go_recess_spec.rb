require 'spec_helper'

describe GoRecess do

  before(:each) do
    json = '{"scheduled_classes": [
            {
                        "id": 13994882,
                                    "bookable": true,
                                                "booking_url": "/bookings/new?scheduled_class_id=13994882",
                                                            "favorited": null,
                                                                        "on_calendar": null,
                                                                                    "price": 20,
                                                                                                "points": null,
                                                                                                            "date": "2013-07-11",
                                                                                                                        "starts": 15300,
                                                                                                                                    "ends": 18900,
                                                                                                                                                "spots_left": null,
                                                                                                                                                            "class_type": {
                                                                                                                                                                            "id": 260335,
                                                                                                                                                                                            "url": "/locations/25000-raise-the-bar/class_types/260335-crossfit-level-1#class-overview?scheduled_class_id=13994882",
                                                                                                                                                                                                            "canonical_url": "https://www.gorecess.com/locations/25000-raise-the-bar/class_types/260335-crossfit-level-1#class-overview?scheduled_class_id=13994882",
                                                                                                                                                                                                                            "name": "CrossFit Level 1",
                                                                                                                                                                                                                                            "tags": [
                                                                                                                                                                                                                                                                  "strength_conditioning"
                                                                                                                                                                                                                                            ],
                                                                                                                                                                                                                                                            "avg_rating": null,
                                                                                                                                                                                                                                                                            "num_reviews": 0,
                                                                                                                                                                                                                                                                                            "review_url": "/locations/25000-raise-the-bar/class_types/260335-crossfit-level-1/reviews/new"
                                                                                                                                                                                                                                                                                                        },
                                                                                                                                                                                                                                                                                                                    "staff": {
                                                                                                                                                                                                                                                                                                                          "id": 68738,
                                                                                                                                                                                                                                                                                                                                          "url": "/locations/25000-raise-the-bar#instructors",
                                                                                                                                                                                                                                                                                                                                                          "name": "Brian Sweeney"
                                                                                                                                                                                                                                                                                                                                                                      },
                                                                                                                                                                                                                                                                                                                                                                                  "friends_attended": [],
                                                                                                                                                                                                                                                                                                                                                                                              "location": {
                                                                                                                                                                                                                                                                                                                                                                                                    "id": 25000,
                                                                                                                                                                                                                                                                                                                                                                                                                    "url": "/locations/25000-raise-the-bar",
                                                                                                                                                                                                                                                                                                                                                                                                                                    "favorited": null,
                                                                                                                                                                                                                                                                                                                                                                                                                                                    "name": "Raise the Bar",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                    "address": " 9046 Hornbaker Road, Suite 101",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    "city": "MANASSAS",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    "region": "VA",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    "postal_code": "20109",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    "country": "US",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    "distance": 375.7,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    "latitude": 38.759695,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    "longitude": -77.533936,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    "avg_rating": 0,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    "num_reviews": 0,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    "tags": [
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          "cardio",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              "strength_conditioning",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  "boot_camp",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      "dance",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          "yoga_meditation_stretch"
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    ]
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                                                                                                                                                                                      }]}'
                                                                                                                                                                                                                                                                                                                                                                      @parsed_json = JSON::parse(json)                                  
  end

  it 'should not raise an error' do
    # workout_id = GoRecess.save_classes_to_database(@parsed_json)
    # workout_id.length.should_not eql(0)
  end

  it 'should make call to go recess' do

    loc = {:lat => 37.77493, :lon => -122.419416}

    #GoRecess.perform(45, loc, DateTime.now)

    loc = {"lat" => 37.77493, "lon" => -122.419416}

    #GoRecess.perform(45, loc, DateTime.now)

    #GoRecess.get_classes(46, DateTime.now, loc)
    #GoRecess.get_classes(44, DateTime.now, loc)
    #GoRecess.get_classes(43, DateTime.now, loc)
  end

  it 'should start location jobs' do
    # GoRecess.get_classes(2, DateTime.now + 2.days, {:lat => 39.103118, :lon => -84.51202} )
    Workout.all.each do |workout|
      puts workout.attributes
    end
  end

  it 'should get class from a location url' do
    place = FactoryGirl.create(:place)
    address = FactoryGirl.create(:valid_address_with_coordinates)
    place.address = address
    place.save
    url = "/locations/52853-kenwood-hot-yoga-yoga-alive"
    date = DateTime.now
    # GoRecess.get_classes_for_location(url, place.id, date)
  end

  it 'should get locations from go recess' do
    GoRecess.get_locations(1, DateTime.now, {:lat => 40.014986, :lon => -105.270546 } ) 

    place = Place.all.last

    # place.can_buy = true
    place.schedule_url = nil
    place.save

    GoRecess.get_locations(1, DateTime.now, {:lat => 40.014986, :lon => -105.270546 } )

    place = Place.find(place.id)

    place.schedule_url.should be_nil
  end
end
