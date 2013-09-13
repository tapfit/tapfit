require 'spec_helper'

describe Mindbody do


  it 'should save a class from mindbody' do
    place = FactoryGirl.create(:place)
    address = FactoryGirl.create(:valid_address_with_coordinates)
    pass_detail = FactoryGirl.build(:pass_detail)
    pass_detail.place_id = place.id
    pass_detail.save
    place.address = address
    place.can_buy = true
    place.dropin_price = nil
    place.save
    place.pass_details.first.should_not be_nil
    url = "https://clients.mindbodyonline.com/ASP/home.asp?studioid=30154"
    puts "url: #{url}, time: #{DateTime.now + 1.days}"
    Mindbody.get_classes(url, place.id, DateTime.now, "test")

    # Mindbody.get_classes(url, place.id, DateTime.now, "test")

    # puts REDIS.lrange(MailerUtils.redis_key, 0, 100)  
    Workout.all.each do |w|
      puts w.attributes
    end
  end

end
