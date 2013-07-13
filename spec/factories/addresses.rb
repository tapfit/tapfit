FactoryGirl.define do
  factory :address do

    factory :valid_address do
      line1 "1507 N Hudson Ave"
      line2 "#1"
      city "Chicago"
      state "IL"
      zip "60610"

      factory :valid_address_with_coordinates do
        lat 41.909528
        lon -87.639746
      end
    end

    factory :invalid_address do
      line1 ""
      line2 ""
      city ""
      state ""
      zip ""
    end

  end
end
