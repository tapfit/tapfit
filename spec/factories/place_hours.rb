# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :place_hour do
    day_of_week 1
    open "2013-09-01 09:00:00"
    close "2013-09-01 17:00:00"
  end
end
