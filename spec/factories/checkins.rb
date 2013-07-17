# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :checkin do
    place_id 1
    user_id 1
    lat 1.5
    lon 1.5
  end
end
