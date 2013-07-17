require 'spec_helper'

describe Workout do
 
  before(:each) do
    @place = FactoryGirl.create(:place)
    @workout = FactoryGirl.create(:workout)
    @old_workout = FactoryGirl.create(:old_workout) 
    @place.workouts << @workout
    @place.workouts << @old_workout
  end

  it 'check default scope' do
    @place.workouts.count.should eql(1)
    @place.workouts.unscoped.count.should eql(2)
  end

end
