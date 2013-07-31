require 'spec_helper'

describe Workout do
 
  before(:all) do
    @place = FactoryGirl.create(:place)
    @address = FactoryGirl.create(:valid_address_with_coordinates)
    @place.address = @address
    @place.save
    @workout = FactoryGirl.create(:workout)
    @old_workout = FactoryGirl.create(:old_workout) 
    @future_workout = FactoryGirl.create(:future_workout)
    @place.workouts << @workout
    @place.workouts << @old_workout
    @place.workouts << @future_workout
  end

  it 'check default scope' do
    puts "Time: #{Time.now.utc.beginning_of_day}"
    @place.todays_workouts.count.should eql(1)
    @place.workouts.unscoped.count.should eql(3)
    
  end

end
