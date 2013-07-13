# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :instructor do
    first_name "MyString"
    last_name "MyString"
    email "MyString"
    photo_url "MyString"
    phone_number "MyString"
  end
end
