require 'spec_helper'

describe Mindbody do


  it 'should save a class from mindbody' do
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


    workout = FactoryGirl.create(:workout)
    workout.workout_key = "2f8f44fa3a62363ef3587337c4da2870d68d73b7"
    workout.price = 12
    workout.original_price = 15
    workout.save

    place.workouts << workout

    url = "https://clients.mindbodyonline.com/ASP/home.asp?studioid=2839"
    puts "url: #{url}, time: #{DateTime.now + 1.days}"
    Mindbody.get_classes(url, place.id, DateTime.now, place.source)

    # Mindbody.get_classes(url, place.id, DateTime.now, "test")

    # puts REDIS.lrange(MailerUtils.redis_key, 0, 100) 
  
    place = Place.find(place.id)

    puts "lowest_price = #{place.lowest_price}"
    puts "lowest_original_price = #{place.lowest_original_price}"

    Workout.all.each do |w|
      puts w.attributes
    end
  end

end
