# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :workout do
    name "MyString"
    start_time "2013-07-13 17:22:15"
    end_time "2013-07-13 17:22:15"
    instructor_id 1
    place_id 1
    source_description "MyText"
    workout_key "kdnekowkd"
    source "MyString"
    is_bookable false
  end
end
