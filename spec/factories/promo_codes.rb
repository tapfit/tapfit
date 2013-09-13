# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :promo_code do
    company_id 1
    code "MyString"
    has_used false
    amount 1.5
  end
end
