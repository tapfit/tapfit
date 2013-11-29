# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :package do
    amount 1
    fit_coins 1
    discount 1.5
  end
end
