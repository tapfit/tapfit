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
    # @user.send_welcome_email
  end

  it 'should get total remaining credits' do
    @user.credit_amount.should eql(40.0)
  end

  it 'should deduct total credits properly' do
    @user.use_credits(30)
    @user.credit_amount.should eql(10.0)
  end 

  it 'should not create a promo code for user with no name' do
    user = FactoryGirl.build(:user)
    user.first_name = nil
    user.last_name = nil
    user.email = "joke@email.com"
    user.save
    user.promo_code.should be_nil
  end

  before(:all) do
    @user2 = FactoryGirl.build(:user)
    @user2.first_name = "Jim"
    @user2.last_name = "Shannon"
    @user2.email = "jim@shannon.com"
    @user2.save
  end

  it 'should create a promocode from first name' do
    promo_id = @user2.promo_code.id
    @user2.first_name = "Jim"
    @user2.last_name = nil
    @user2.save
    sleep(1)
    user = User.find(@user2.id)
    user.promo_code.id.should eql(promo_id)
    user.promo_code.code.should eql(user.first_name)
  end

  it 'should create promo code from last name' do
    @user2.first_name = nil
    @user2.last_name = "Shannon"
    @user2.save
    sleep(1)
    user = User.find(@user2.id)
    user.promo_code.code.should eql(user.last_name)
  end

  it 'should keep promo code if not changing name' do
    promo_code = @user.promo_code
    @user.email = "12334@mail.com"
    @user.save
    user = User.find(@user.id)
    user.promo_code.code.should eql(promo_code.code)
  end

  it 'should create a promo code for a new user' do
    promo_code = "#{@user.first_name[0]}#{@user.last_name}"
    @user.promo_code.code.should eql(promo_code)
  end

  it 'should add wildcard to end of duplicate promo code' do
    user = FactoryGirl.build(:user)
    user.email = "joke1@gmail.com"
    user.save
    promo_code = "#{user.first_name[0]}#{user.last_name}1"
    user = User.find(user.id)
    user.promo_code.code.should eql(promo_code)
  end
end
