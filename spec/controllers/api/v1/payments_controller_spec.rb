require 'spec_helper'

describe Api::V1::PaymentsController do

  before(:all) do

    @user = FactoryGirl.create(:user)
    @user.reset_authentication_token!    
    
  end
 
  describe 'POST #create' do 
    before(:each) do
      
      @attr = 
      {
        :user_id => "me",
        :card_number => 4111111111111111,
        :expiration_month => 4,
        :expiration_year => 16,
        :venmo_sdk_session => Braintree::Test::VenmoSDK::Session
      }

    end
    it 'should add a credit card to a user who does not have a braintree id yet' do
      Braintree::Customer.delete(1937402)
      @attr[:auth_token] = @user.authentication_token
      @user.id = 1937402
      @user.save
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
      Braintree::Customer.delete(@user.id)
      result = Braintree::Customer.create(
        :first_name => @user.first_name,
        :last_name => @user.last_name,
        :id => @user.id
      )
      @user.braintree_customer_id = @user.id
      @user.save
      @attr[:auth_token] = @user.authentication_token
      post :create, @attr
      response.body.should include("true")
    end
  end

  describe "PUT default" do
     
    it 'should update credit card on file' do
      @attr = {}
      @attr[:expiration_year] = 16  
      @attr[:expiration_month] = 6
      @attr[:number] = 4111111111111111
      @attr[:customer_id] = @user.id
      
      Braintree::CreditCard.create(
        @attr  
      )

      @attr[:expiration_month] = 8

      Braintree::CreditCard.create(
        @attr
      )
      
      token = nil
      customer = Braintree::Customer.find(@user.id)
      customer.credit_cards.each do |cc|
        if !cc.default?
          token = cc.token
          break
        end
      end
      
      new_token = nil
      @user.braintree_customer_id = @user.id
      @user.save
      puts "braintree_id: #{@user.braintree_customer_id}"
      @user.reset_authentication_token!
      put :default, token: token, auth_token: @user.authentication_token, user_id: "me"
      response.body.should include("true")
      customer = Braintree::Customer.find(@user.id)
      customer.credit_cards.each do |cc|
        if cc.default?
          new_token = cc.token
        end
      end

      token.should eql(new_token)
    end

  end

  describe "DELETE #delete" do

    it 'should delete a workout' do
      
      @attr = {}
      @attr[:expiration_year] = 16  
      @attr[:expiration_month] = 6
      @attr[:number] = 4111111111111111
      @attr[:customer_id] = @user.id

      Braintree::CreditCard.create(
        @attr
      )
      
      token = nil
      customer = Braintree::Customer.find(@user.id)
      customer.credit_cards.each do |cc|
        token = cc.token
      end

      puts "token: #{token}"
      delete :delete, token: token, auth_token: @user.authentication_token, user_id: "me"

      has_token = false
      customer = Braintree::Customer.find(@user.id)
      customer.credit_cards.each do |cc|
        has_token = ( cc.token == token )
      end

      has_token.should be_false
    end

  end

end
