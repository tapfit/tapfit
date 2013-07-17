# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rating do
    rating 5
    user_id 1
    workout_key ""
    workout_id 1
    place_id 1
    review "MyText"
  end
end
