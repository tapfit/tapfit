# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contest do
    name "MyString"
    url "MyString"
    body "MyString"
    start_date "2014-01-07 18:22:51"
    end_date "2014-01-07 18:22:51"
    is_live false
  end
end
