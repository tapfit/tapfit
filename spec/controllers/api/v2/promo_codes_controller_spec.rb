require 'spec_helper'

describe Api::V1::PromoCodesController do

  before(:each) do
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
    @user1 = User.find(@user1.id)
    @user2 = User.find(@user2.id)
    @user3 = User.find(@user3.id)
  end 

  it 'should not redeem code for 3rd person' do
    post :create, user_id: "me", auth_token: @user1.authentication_token, promo_code: @promo_code.code
    response.body.should include("user")
    sign_out(@user1)
    @user1.authentication_token = nil
    @user1.save
    User.find(@user1.id).destroy
    post :create, user_id: @user2.id, auth_token: @user2.authentication_token, promo_code: @promo_code.code
    response.body.should include("user")
    sign_out(@user2)
    @user2.authentication_token = nil
    @user2.save
    @user2.destroy
    User.find(@user2.id).destroy
    post :create, user_id: @user3.id, auth_token: @user3.authentication_token, promo_code: @promo_code.code
    response.body.should include("already been used")
  end

  it 'should redeem invitation from another' do
    @user1.promo_code.code.should eql("ZMartinsek")
    @user2.promo_code.code.should eql("ZMartinsek3")
    @user3.promo_code.code.should eql("ZMartinsek1")

    @user1.ensure_authentication_token!

    post :create, user_id: "me", auth_token: @user1.authentication_token, promo_code: "zmartinsek3"
    response.body.should include("user")

    post :create, user_id: "me", auth_token: @user1.authentication_token, promo_code: "zmartinsek1"
    response.body.should include("Sorry")
  end

  it 'should not redeem for someone who has purchased' do
    @user1.ensure_authentication_token!

    receipt = FactoryGirl.build(:receipt)
    receipt.user_id = @user1.id
    receipt.save

    post :create, user_id: "me", auth_token: @user1.authentication_token, promo_code: "zmartinsek"
    response.body.should include("Sorry") 
  end

end
