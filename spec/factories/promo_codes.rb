# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :promo_code do
    company_id 1
    code "55555"
    has_used false
    amount 2
    quantity 2
  end
end
