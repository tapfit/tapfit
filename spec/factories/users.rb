# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email "zackmartinsek@gmail.com"
    password "medo1234"
    first_name "Zack"
    last_name "Martinsek"
  end
end
