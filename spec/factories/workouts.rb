# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :workout do
    name "MyString"
    start_time Time.parse("10:00:00")
    end_time Time.now.utc + 2.hours
    instructor_id 1
    place_id 1
    price 10.00
    source_description "MyText"
    workout_key "kdnekowkd"
    source "MyString"
    is_bookable false
    can_buy true

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
