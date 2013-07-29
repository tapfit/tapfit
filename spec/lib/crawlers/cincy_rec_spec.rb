require 'spec_helper'

describe CincyRec do
  
  it 'should save cincy rec locations' do
    num = 348
    while num < 354 do
      CincyRec.get_place(num)
      num = num + 1
    end
    Place.where(:name => "Withrow").count.should eql(1)
  end

end
