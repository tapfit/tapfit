require 'spec_helper'

describe Receipt do
  
  before(:each) do
    @place = FactoryGirl.create(:place)
    @workout = FactoryGirl.create(:workout)
    @user = FactoryGirl.build(:user)
    @user.email = "scott@tapfit.co"
    @user.save
  end

  it 'should send receipt email' do
    receipt = Receipt.create(:place_id => @place.id, :workout_id => @workout.id, :workout_key => @workout.workout_key, :user_id => @user.id, :has_booked => false, :price => 10)

    receipt.send_receipt_email 
  end 
end
