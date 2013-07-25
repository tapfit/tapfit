require 'spec_helper'

describe CincyRec do
  
  it 'should save cincy rec locations' do
    num = 1
    while num < 1000 do
      CincyRec.get_place(num)
      num = num + 1
    end
    Place.where(:source => "cincyrec").count.should eql(1)
  end

end
