require 'spec_helper'

describe Fitness24Hour do

  it 'should get locations' do
    num = 955
    while num < 956 do
      # Fitness24Hour.get_locations(num)
      num += 1
    end
  end

  it 'should get classes for a locaiton' do
    num = 957

    while num < 958 do
      Fitness24Hour.get_classes(num, DateTime.now)
      num += 1
    end
  end
end
