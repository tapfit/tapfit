require 'spec_helper'

describe Favorite do
 
  before(:all) do
    @user = FactoryGirl.create(:user)
    @place = FactoryGirl.create(:place)
    @workout = FactoryGirl.create(:workout)
  end

  it 'validates Favorite model' do
    favorite = Favorite.new(:user_id => @user.id)
    favorite.valid?.should be_false
    favorite = Favorite.new(:place_id => @place.id)
    favorite.valid?.should be_false
    favorite = Favorite.new(:user_id => @user.id, :place_id => @place.id)
    favorite.valid?.should be_true
  end

  it 'validates FavoritePlace model' do
    favorite = FavoritePlace.new(:user_id => @user.id)
    favorite.valid?.should be_false
    favorite = FavoritePlace.new(:place_id => @place.id)
    favorite.valid?.should be_false
    favorite = FavoritePlace.new(:user_id => @user.id, :place_id => @place.id)
    favorite.valid?.should be_true
  end

  it 'validates FavoriteWorkout model' do
    favorite = FavoriteWorkout.new(:user_id => @user.id)
    favorite.valid?.should be_false
    favorite = FavoriteWorkout.new(:place_id => @place.id)
    favorite.valid?.should be_false
    favorite = FavoriteWorkout.new(:workout_id => @workout.id, :workout_key => @workout.workout_key)
    favorite.valid?.should be_false
    favorite = FavoriteWorkout.new(:user_id => @user.id, :place_id => @place.id, :workout_id => @workout.id, :workout_key => @workout.workout_key)
    favorite.valid?.should be_true
  end

end
