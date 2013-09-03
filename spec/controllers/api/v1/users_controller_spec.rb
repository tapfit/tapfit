require 'spec_helper'

describe Api::V1::UsersController do
  
  before(:each) do
    @user = FactoryGirl.build(:user)
  end

  describe "POST #guest" do
    
    it 'saves a guest' do
      post :guest
      response.body.should include("guest")
      user = User.where(:is_guest => true).first
      puts user.email
    end

    it 'updates a user from guest to user' do

      attr = 
      {
        :email => @user.email,
        :password => @user.password,
        :first_name => @user.first_name,
        :last_name => @user.last_name
      }
      # post :register, user: attr


      post :guest
      response.body.should include("guest")
      user = User.where(:is_guest => true).first
      attr[:email] = "ben@example.com"
      post :register, user: attr, auth_token: user.authentication_token
      User.where(:is_guest => true).count.should eql(0)
      User.all.last.id.should eql(user.id)
      user = User.all.last
      user.has_payment_info?.should be_true
    end

  end

  describe "POST #register" do
    
    it 'fails to load user if no email/password' do
      @user.email = nil
      post :register, user: @user.attributes
      response.body.should include("error")
    end  

    it 'registers user with valid email/password' do
      @attr = 
        {
          :email => @user.email,
          :password => @user.password,
          :first_name => @user.first_name,
          :last_name => @user.last_name
        }
      puts @attr
      post :register, user: @attr
      response.body.should include("auth_token")
      user = User.where(:email => @user.email).first
      #user.last_name.should eql(@user.last_name)
      response.body.should include(@user.last_name)
    end

    it 'does not allow duplicate users' do
      @user.save
      post :register, user: @user.attributes
      response.body.should include("error")
    end
  end  

  describe "POST #login" do
    it 'signs in an existing user' do
      @user.save
      post :login, email: @user.email, password: @user.password
      response.body.should include(@user.last_name)
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

  describe "GET #show" do
    
    before(:each) do
      @user2 = FactoryGirl.build(:user)
      @user2.email = "new@email.com"
      @user2.save
      @user.save

      @user2.ensure_authentication_token!
      @user.ensure_authentication_token!
    end

    it 'should show me as user with auth token' do
      get :show, auth_token: @user.authentication_token
      response.body.should include(@user.email.to_s)
    end

    it 'should not show anything without auth token' do
      get :show
      response.body.should include("redirected")
    end

    it 'should not cache users' do
      get :show, auth_token: @user.authentication_token
      sleep(5)
      get :show, auth_token: @user2.authentication_token
      response.body.should include(@user2.email.to_s)
    end

  end

end
