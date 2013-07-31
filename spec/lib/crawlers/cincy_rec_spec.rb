require 'spec_helper'

describe CincyRec do
  
  it 'should save cincy rec locations' do
    num = 354
    while num < 365 do
      place_id = CincyRec.get_place(num)
      if !place_id.nil?
        place = Place.find(place_id)
        if place.name.include?("Washington Park")
          puts "num: #{num}, name: #{place.name}"
          break
        end
      end
      num = num + 1
    end
    #Place.where(:name => "Withrow").count.should eql(1)
  end

end
