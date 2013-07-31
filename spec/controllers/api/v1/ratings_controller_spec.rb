require 'spec_helper'

describe Api::V1::RatingsController do

  before(:all) do
    @user = FactoryGirl.create(:user)
    @user.ensure_authentication_token!
    @place = FactoryGirl.create(:place)
    @rating = FactoryGirl.build(:rating)
  end

  describe 'POST #create' do

    it 'should create a rating for a place' do
      post :create, place_id: @place.id, auth_token: @user.authentication_token, rating: @rating.attributes
      @place.ratings.count.should eql(1)
    end

  end

  describe 'GET #index' do
    
    def create_rating
      post :create, place_id: @place.id, auth_token: @user.authentication_token, rating: @rating.attributes
    end

    it 'should show all ratings for a place' do
      create_rating
      create_rating
      create_rating
      create_rating
      get :index, place_id: @place.id
      response.body.should include("total_entries")
    end

  end


end
