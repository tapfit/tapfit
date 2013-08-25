require 'spec_helper'

describe Mindbody do


  it 'should save a class from mindbody' do
    place = FactoryGirl.create(:place)
    address = FactoryGirl.create(:valid_address_with_coordinates)
    place.address = address
    place.can_buy = true
    place.save
    url = "https://clients.mindbodyonline.com/ASP/home.asp?studioid=30154&tabID=102"
    puts "url: #{url}, time: #{DateTime.now + 1.days}"
    Mindbody.get_classes(url, place.id, DateTime.now + 1.days, "test")

    Workout.all.each do |w|
      puts w.attributes
    end
  end



end
