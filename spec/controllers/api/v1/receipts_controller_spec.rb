require 'spec_helper'

describe Api::V1::ReceiptsController do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.ensure_authentication_token!

    @receipt = FactoryGirl.build(:receipt)
    @receipt.user_id = @user.id
    @receipt.save
  end

  it 'should return list of receipt for a user' do
    get :index, auth_token: @user.authentication_token, user_id: 'me'
    assigns(:receipts).to_a.should eql([@receipt])
  end

  it 'should return a single receipt for a user' do
    get :show, auth_token: @user.authentication_token, user_id: 'me'
    assigns(:receipt).should eql(@receipt)
  end

  it 'should not show receipts for non-user' do
    get :index, user_id: 'me'
    response.body.should include("redirected")
  end

end
