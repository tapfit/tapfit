require 'spec_helper'

describe Moksha do

  it 'should grab all studios for moksha' do
  
    Rails.logger = Logger.new(STDOUT)
    
    Moksha.get_locations

    Place.where(:source => "moksha").each do |place|
      # Rails.logger.debug place.attributes
    end 
  end

  it 'should get schedule info' do
    
    place = FactoryGirl.build(:place)
    place.dropin_price = 15
    address = FactoryGirl.create(:valid_address_with_coordinates)
    place.address = address
    place.save

    Moksha.get_classes("http://minneapolis.mokshayoga.ca/", place.id, DateTime.now)

    puts "Time: #{Time.now.beginning_of_day.utc}"
    place.todays_workouts.count.should eql(10)
    place.todays_workouts.each do |workout|
      puts workout.start_time
    end

  end

end
