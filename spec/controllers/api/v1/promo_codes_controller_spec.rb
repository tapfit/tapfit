require 'spec_helper'

describe Api::V1::PromoCodesController do

  before(:all) do
    @promo_code = FactoryGirl.create(:promo_code)
    @promo_code.quantity = 2
    @promo_code.save
    @user1 = FactoryGirl.build(:user)
    @user2 = FactoryGirl.build(:user)
    @user3 = FactoryGirl.build(:user)

    @user1.email = "12345@mail.com"
    @user2.email = "123456@mail.com"
    @user3.email = "1234567@mail.com"
    @user1.save
    @user2.save
    @user3.save
    @user1.ensure_authentication_token!
    @user2.ensure_authentication_token!
    @user3.ensure_authentication_token!
  end 

  it 'should not redeem code for 3rd person' do
    post :create, user_id: "me", auth_token: @user1.authentication_token, promo_code: @promo_code.code
    response.body.should include("user")
    sign_out(@user1)
    @user1.authentication_token = nil
    @user1.save
    User.find(@user1.id).destroy
    post :create, user_id: "me", auth_token: @user2.authentication_token, promo_code: @promo_code.code
    response.body.should include("user")
    sign_out(@user2)
    @user2.authentication_token = nil
    @user2.save
    @user2.destroy
    User.find(@user2.id).destroy
    post :create, user_id: "me", auth_token: @user3.authentication_token, promo_code: @promo_code.code
    response.body.should include("already been used")
  end

end
