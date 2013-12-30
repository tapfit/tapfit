# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tracking do
    distinct_id "MyString"
    utm_medium "MyString"
    utm_source "MyString"
    utm_campaign "MyString"
    utm_content "MyString"
    download_iphone false
    download_android false
    hexicode "MyString"
  end
end
