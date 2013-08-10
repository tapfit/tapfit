# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :receipt do
    place_id 1
    user_id 1
    workout_id 1
    price 1.5
    workout_key ""
    expiration_date "2013-08-10 16:57:59"
    has_used false
  end
end
