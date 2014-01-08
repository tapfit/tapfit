# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contestant do
    email "MyString"
    has_downloaded false
    has_shared false
    index "MyString"
    show "MyString"
    new "MyString"
  end
end
