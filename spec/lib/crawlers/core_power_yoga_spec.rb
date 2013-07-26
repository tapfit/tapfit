require 'spec_helper'

describe CorePower do

  it 'should get all location urls and schedule urls' do
    # CorePower.get_studio_urls
  end

  it 'should get location info' do
    # CorePower.get_location_info("Berkley Studio", "http://www.corepoweryoga.com/yoga-studio/illinois/streeterville", "url") 
  end

  it 'should get classes for location' do
    CorePower.get_class_info("Berkeley Studio", "http://www.corepoweryoga.com/yoga-studio/california/berkeley", "http://www.corepoweryoga.com/yoga-studio/California/schedule/4")
  end
end
