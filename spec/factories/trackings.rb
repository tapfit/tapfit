# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tracking do
    distinct_id "kdkdkdkdkddk"
    utm_medium "Email"
    utm_source "MailChimp"
    utm_campaign "Reactivate"
    utm_content "Free Credits"
    download_iphone false
    download_android false
    user_id 5
  end
end
