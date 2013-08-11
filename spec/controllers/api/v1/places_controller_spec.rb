require 'spec_helper'

describe Api::V1::PlacesController do

  before(:each) do
    @place = FactoryGirl.create(:place)
    @address = FactoryGirl.create(:valid_address_with_coordinates)
    @place.address_id = @address.id
    @place.save
  end


  describe 'GET #index' do
    it 'returns list of places around you' do
      get :index, lat: 39.110918, lon: -84.515521
      assigns(:places).to_a.should eql([@place])
      #response.body.should eql("")
    end
  end

  describe 'GET #show' do
    
    it 'returns a specific place' do
      get :show, id: @place.id
      assigns(:place).should eql(@place)
    end
  end

  describe 'POST #favorite' do

    before(:each) do
      @user = FactoryGirl.build(:user)
      @user = User.where(:email => @user.email).first
      @user = FactoryGirl.create(:user) if @user.nil?
      @user.ensure_authentication_token!

    end
    it 'should favorite a place' do
      post :favorite, id: @place.id, auth_token: @user.authentication_token
      favorite = FavoritePlace.where(:user_id => @user.id, :place_id => @place.id).first
      favorite.should_not be_nil      
      @user.favorite_places.where(:id => favorite.id).first.should_not be_nil
      response.body.should include("1")
    end

    it 'should unfavorite a place' do
      post :favorite, id: @place.id, auth_token: @user.authentication_token
      post :favorite, id: @place.id, auth_token: @user.authentication_token
      favorite = FavoritePlace.where(:user_id => @user.id, :place_id => @place.id).first
      favorite.should be_nil
      response.body.should include("0")
    end

    it 'should not allow an unauthorized user to access' do
      post :favorite, id: @place.id
      response.body.should include("redirected")
    end

    it 'should not allow a guest user to access' do
      @user.is_guest = true
      @user.save
      post :favorite, id: @place.id, auth_token: @user.authentication_token
      response.body.should include("register")
    end
  end

  describe 'POST #checkin' do
    
    before(:all) do
      @user = FactoryGirl.create(:user)
      @user.ensure_authentication_token!
    end

    it 'should checkin to a place' do
      post :checkin, id: @place.id, auth_token: @user.authentication_token
      checkin = Checkin.where(:user_id => @user.id, :place_id => @place.id).first
      @user.checkins.where(:id => checkin.id).first.should_not be_nil
      response.body.should include("1")
    end

  end

end
