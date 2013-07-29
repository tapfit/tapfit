require 'spec_helper'

describe Api::V1::FavoritesController do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @place = FactoryGirl.create(:place)
    @address = FactoryGirl.create(:valid_address_with_coordinates)
    @place.address = @address
    @place.save 
    @favorite = FavoritePlace.create(:user_id => @user.id, :place_id => @place.id)

  end

  it 'should show all favorite places for user' do
    @user.ensure_authentication_token!
    get :index, user_id: @user.id, auth_token: @user.authentication_token
    assigns(:places).to_a.should eql([@place])
  end

  it 'should not show places if not authenticated' do
    get :index, user_id: @user.id
    response.body.should include("redirected")
  end

end
