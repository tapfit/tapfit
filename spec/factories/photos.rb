# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :photo do
    url "MyString"
    user_id 1
    workout_key ""
    place_id 1
  end
end
