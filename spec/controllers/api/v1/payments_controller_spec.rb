require 'spec_helper'

describe Api::V1::PaymentsController do

  before(:each) do

    @user = FactoryGirl.create(:user)
    @user.ensure_authentication_token!
    
    
  end
 
  describe 'POST #create' do 
    before(:each) do
      
      @attr = 
      {
        :user_id => "me",
        :credit_card => 4111111111111111,
        :expiration_month => 4,
        :expiration_year => 16,
        :venmo_sdk_session => Braintree::Test::VenmoSDK::Session,
      }

    end
    it 'should add a credit card to a user who does not have a braintree id yet' do
      @attr[:auth_token] = @user.authentication_token
      post :create, @attr
      response.body.should include("true")
      user = User.find(@user.id)
      user.braintree_customer_id.should_not be_nil
    end

    it 'should not add a credit card to a non-registered user' do
      post :create, @attr
      response.body.should include("redirected")
    end

    it 'should add a credit card to a user with a braintree account' do
      result = Braintree::Customer.create(
        :first_name => @user.first_name,
        :last_name => @user.last_name
      )
      @user.braintree_customer_id = result.customer.id
      @user.save
      @attr[:auth_token] = @user.authentication_token
      post :create, @attr
      response.body.should include("true")
    end
  end

  describe 'POST #usercard' do
    it 'should use credit card for a user' do
      @attr = 
      {
        :user_id => "me",
        :auth_token => @user.authentication_token,
        :venmo_sdk_payment_method_code =>  
          Braintree::Test::VenmoSDK.generate_test_payment_method_code("4111111111111111")
      }

      post :usecard, @attr
    end
  end

end
