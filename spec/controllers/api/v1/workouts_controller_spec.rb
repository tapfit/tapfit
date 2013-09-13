require 'spec_helper'

describe Api::V1::WorkoutsController do

  before(:each) do
    @place = FactoryGirl.create(:place)
    @address = FactoryGirl.create(:valid_address_with_coordinates)
    @place.address = @address
    @place.save
    @workout = FactoryGirl.create(:workout)
    @place.workouts << @workout
    puts @place.id
    @place.save
  end

  describe 'GET #index' do
    it 'should give me all worktous for a place' do
      get :index, place_id: @place.id
      assigns(:workouts).to_a.should eql([@workout])
    end

    it 'should not show workout for invalid place' do
      get :index, place_id: -1
      response.body.should include("errors") 
    end
  end

  describe 'GET #show' do
    it 'should show me on workout' do
      get :show, place_id: @place.id, id: @workout.id
      assigns(:workout).should eql(@workout)
    end
  end

  describe 'POST #buy' do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @user.ensure_authentication_token!

      result = Braintree::Customer.create(
        :first_name => @user.first_name,
        :last_name => @user.last_name,
        :credit_card => {
          :number => "4111111111111111",
          :expiration_month => 4,
          :expiration_year => 16
        }
      )

      @user.braintree_customer_id = result.customer.id
      @user.save

      @attr =
      {
        :auth_token => @user.authentication_token,
        :venmo_sdk_payment_method_code =>
          Braintree::Test::VenmoSDK.generate_test_payment_method_code("4111111111111111"),
        :place_id => @place.id,
        :id => @workout.id      
      }
      
      @credit = FactoryGirl.build(:credit)
      @credit.total = 20
      @credit.expiration_date = DateTime.now + 5.days
      @credit.save
      @user.credits << @credit

    end

    it 'should say user does not have a credit card' do

      @user.braintree_customer_id = nil
      @user.save

      post :buy, @attr     
      response.body.should include("no credit card")
    end

    it 'should use credits for user if it has them' do
      post :buy, @attr
      response.body.should include("true")
      @user.credit_amount.should eql(20 - @workout.price)
    end

    it 'should buy a pass for a user with a credit card' do
      post :buy, @attr
      response.body.should include("true")
      receipt = Receipt.where(:workout_id => @workout.id).first
      receipt.should_not be_nil
      receipt.has_used.should be_false
    end

    it 'should not buy pass for a non-registered user' do
      @attr[:auth_token] = nil
      post :buy, @attr
      response.body.should include("redirected")
    end

    it 'should not buy if you cannot buy workout' do
      @workout.can_buy = false
      @workout.save

      post :buy, @attr
      response.body.should include("Can't buy workout")
    end

    it 'should not buy a workout if workout does not exist' do
      @attr[:id] = 993898273
      post :buy, @attr
      response.body.should include(@attr[:id].to_s)
    end
  end

end
