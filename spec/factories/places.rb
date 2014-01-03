# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :place do
    name "MyString"
    source "MyString"
    source_key ""
    url "MyString"
    phone_number "MyString"
    tapfit_description "MyText"
    source_description "MyText"
    is_public true

    dropin_price 1.5
    can_buy true
    after(:create) {|instance| address_id = FactoryGirl.create(:valid_address_with_coordinates).id}
  end
end
