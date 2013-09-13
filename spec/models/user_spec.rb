require 'spec_helper'

describe User do

  before(:all) do
    @place = FactoryGirl.create(:place)
    @user = FactoryGirl.create(:user)
    @credit = FactoryGirl.build(:credit)
    @credit1 = FactoryGirl.build(:credit)
    @total_credits = 20
    @credit.total = @total_credits
    @credit1.total = @total_credits
    @credit.expiration_date = DateTime.now + 5.days
    @credit1.expiration_date = DateTime.now + 5.days
    @credit.save
    @credit1.save
    @user.credits << @credit
    @user.credits << @credit1
  end
  it 'should build a new review for a place' do
    params = 
      {
        :rating => "4",
        :review => "This place is awesome"
      }

    rating = @user.write_review_for_place(params, @place.id)
    rating.save.should_not raise_error
    @place.avg_rating.should eql(4.0)
  end

  it 'should send email' do
    @user.email = "scott@tapfit.co"
    @user.is_guest = false
    @user.save
    @user.send_welcome_email
  end

  it 'should get total remaining credits' do
    @user.credit_amount.should eql(40.0)
  end

  it 'should deduct total credits properly' do
    @user.use_credits(30)
    @user.credit_amount.should eql(10.0)
  end 
end
