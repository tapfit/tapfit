# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :place do
    name "MyString"
    address_id 1
    source "MyString"
    source_key ""
    url "MyString"
    category "MyString"
    phone_number "MyString"
    tapfit_description "MyText"
    source_description "MyText"
    is_public false
    can_dropin false
    dropin_price 1.5
  end
end
