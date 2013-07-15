require 'spec_helper'

describe Api::V1::UsersController do
  
  before(:each) do
    @user = FactoryGirl.build(:user)
  end

  describe "POST #register" do
    
    it 'fails to load user if no email/password' do
      post :register, email: nil, password: @user.password
      response.body.should include("error")
    end  

    it 'registers user with valid email/password' do
      post :register, email: @user.email, password: @user.password
      response.body.should include("auth_token")
    end

    it 'does not allow duplicate users' do
      @user.save
      post :register, email: @user.email, password: @user.password
      response.body.should include("error")
    end
  end  

  describe "POST #login" do
    it 'signs in an existing user' do
      @user.save
      post :login, email: @user.email, password: @user.password
      response.body.should include("auth_token")
    end

    it 'does not allow a user to sign in that is not an existing user' do
      post :login, email: @user.email, password: @user.password
      response.body.should include("error")
    end
  end

  describe "POST #logout" do
    it 'logouts a user out' do
      @user.save
      sign_in(:user, @user)
      @user.ensure_authentication_token!
      post :logout, auth_token: @user.authentication_token
      User.find(@user.id).authentication_token.should be_nil
    end
  end

  describe "POST #forgotpassword" do
    it 'sends email if email in database' do
      @user.save
      post :forgotpassword, email: @user.email
      (!ActionMailer::Base.deliveries.empty?).should be_true
    end
  end

end
