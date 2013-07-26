require 'spec_helper'

describe Api::V1::CheckinsController do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @place = FactoryGirl.create(:place)
    
    @checkin = Checkin.create(:user_id => @user.id, :place_id => @place.id)

  end

  it 'should show all checkins for user' do
    @user.ensure_authentication_token!
    get :index, user_id: @user.id, auth_token: @user.authentication_token
    assigns(:checkins).to_a.should eql([@checkin])
  end

  it 'should not show checkins if not authenticated' do
    get :index, user_id: @user.id
    response.body.should include("redirected")
  end

end
