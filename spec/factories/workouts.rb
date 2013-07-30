# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :workout do
    name "MyString"
    start_time Time.now.utc + 1.hours
    end_time Time.now.utc + 2.hours
    instructor_id 1
    place_id 1
    source_description "MyText"
    workout_key "kdnekowkd"
    source "MyString"
    is_bookable false

    factory :old_workout do
      start_time Time.now - 5.days
      end_time Time.now - 4.days
    end

    factory :future_workout do
      start_time Time.now + 4.days
      end_time Time.now + 5.days
    end
  end
end
