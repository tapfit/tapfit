require 'spec_helper'

describe CorePower do

  it 'should get all location urls and schedule urls' do
    CorePower.get_studio_urls
  end

  it 'should get location info' do
    # CorePower.get_location_info("Berkley Studio", "http://www.corepoweryoga.com/yoga-studio/illinois/streeterville", "url") 
  end
end
