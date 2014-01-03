require 'spec_helper'

describe Receipt do
  
  before(:each) do
    @place = FactoryGirl.create(:place)
    @address = FactoryGirl.create(:valid_address_with_coordinates)
    @place.address = @address
    @workout = FactoryGirl.create(:workout)
    @place.workouts << @workout
    @place.save
    @workout.save
    @user = FactoryGirl.build(:user)
    @user.email = "zack@tapfit.co"
    @user.save
  end

  it 'should send receipt email' do

    puts @place.address

    receipt = Receipt.create(:place_id => @place.id, :workout_id => @workout.id, :workout_key => @workout.workout_key, :user_id => @user.id, :has_booked => false, :price => 10)

    puts @workout.start_time
    puts @workout.local_start_time

    receipt.send_receipt_email 
  end 
end
