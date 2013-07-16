# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :favorite do
    workout_key ""
    workout_id 1
    user_id 1
    place_id 1
  end
end
