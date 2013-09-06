# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :pass_detail do
    place_id 1
    fine_print "MyText"
    instructions "MyText"
  end
end
