# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :region do
    name "MyString"
    city "MyString"
    state "MyString"
    lat 1.5
    lon 1.5
    radius 1
  end
end
