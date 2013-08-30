require 'spec_helper'

describe Mindbody do


  it 'should save a class from mindbody' do
    place = FactoryGirl.create(:place)
    address = FactoryGirl.create(:valid_address_with_coordinates)
    place.address = address
    place.can_buy = true
    place.save
    url = "http://clients.mindbodyonline.com/ws.asp?studio=PendletonPilates&stype=1&sLoc=2"
    puts "url: #{url}, time: #{DateTime.now + 1.days}"
    Mindbody.get_classes(url, place.id, DateTime.now + 1, "test")

    # Mindbody.get_classes(url, place.id, DateTime.now, "test")


    Workout.all.each do |w|
      puts w.attributes
    end
  end



end
