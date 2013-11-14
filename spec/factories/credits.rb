# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :credit do
    total 20
    remaining 20
    expiration_date "2013-09-13 12:29:09"
    user_id 1
    promo_code_id 1
  end
end
