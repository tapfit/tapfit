require 'spec_helper'

describe DayPass do

  before(:all) do
    @place = FactoryGirl.create(:place)
    @address = FactoryGirl.create(:valid_address_with_coordinates)
    @place.address = @address
    @place.save
    @place_hour = FactoryGirl.create(:place_hour)
    @place_hour.day_of_week = DateTime.now.wday
    @place_hour.save
    @place.place_hours << @place_hour
  end

  it 'should create a day pass for gyms' do
    DayPass.create_day_pass(@place, @place_hour, DateTime.now)
    @place.workouts.count.should eql(1)
    puts @place.workouts.first.attributes
  end

  it 'should not create a day pass for gyms not on a day' do
    @place_hour.day_of_week = 3
    @place_hour.save
    DayPass.create_day_pass(@place, @place_hour, DateTime.now)
    @place.workouts.count.should eql(0)
  end


end 
