require 'spec_helper'

describe Workout do
 
  before(:all) do
    @place = FactoryGirl.create(:place)
    @workout = FactoryGirl.create(:workout)
    @old_workout = FactoryGirl.create(:old_workout) 
    @future_workout = FactoryGirl.create(:future_workout)
    @place.workouts << @workout
    @place.workouts << @old_workout
    @place.workouts << @future_workout
  end

  it 'check default scope' do
    @place.workouts.count.should eql(1)
    @place.workouts.unscoped.count.should eql(3)
  end

end
