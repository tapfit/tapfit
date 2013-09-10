require 'spec_helper'

describe User do

  before(:all) do
    @place = FactoryGirl.create(:place)
    @user = FactoryGirl.create(:user)
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
end
