FactoryGirl.define do
  factory :address do

    factory :valid_address do
      line1 "1215 Vine St"
      line2 ""
      city "Cincinnati"
      state "OH"
      zip "45202"

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
