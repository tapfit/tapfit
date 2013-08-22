require 'spec_helper'

describe Api::V1::RatingsController do

  before(:all) do
    @user = FactoryGirl.create(:user)
    @user.ensure_authentication_token!
    @place = FactoryGirl.create(:place)
    @rating = FactoryGirl.build(:rating)
    @workout = FactoryGirl.create(:workout)
    @place.workouts << @workout
  end

  describe 'POST #create' do

    it 'should create a rating for a place' do
      post :create, place_id: @place.id, auth_token: @user.authentication_token, rating: @rating.attributes
      @place.ratings.count.should eql(1)
    end

    it 'should create a rating for a workout' do
      post :create, place_id: @place.id, auth_token: @user.authentication_token, rating: @rating.attributes, workout_id: @workout.id
      @workout.ratings.count.should eql(1)
      @place.ratings.count.should eql(1)
    end 

  end

  describe 'GET #index' do
    
    def create_rating
      post :create, place_id: @place.id, auth_token: @user.authentication_token, rating: @rating.attributes
    end

    def create_workout_rating
      post :create, place_id: @place.id, auth_token: @user.authentication_token, rating: @rating.attributes, workout_id: @workout.id
    end

    it 'should show all ratings for a place' do
      create_rating
      create_rating
      create_rating
      create_rating
      get :index, place_id: @place.id
      response.body.should include("total_entries")
      assigns(:ratings).to_a.should eql(Rating.where(:place_id => @place.id).to_a)
    end

    it 'should show all ratings for a workout' do
      create_rating
      create_rating
      create_workout_rating
      create_workout_rating
      get :index, place_id: @place.id
      assigns(:ratings).to_a.count.should eql(4)
      get :index, place_id: @place.id, workout_id: @workout.id
      assigns(:ratings).to_a.count.should eql(2)
    end

  end


end
