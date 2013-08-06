require 'spec_helper'

describe CorePower do

  it 'should get all location urls and schedule urls' do
    # CorePower.get_studio_urls
  end

  it 'should get location info' do
    # CorePower.get_location_info("Berkley Studio", "http://www.corepoweryoga.com/yoga-studio/illinois/streeterville", "url") 
  end

  it 'should get classes for location' do
    url = "http://www.corepoweryoga.com/yoga-studio/california/berkeley"
    name = "Berkeley Studio"
    schedule = "http://www.corepoweryoga.com/yoga-studio/California/schedule/4"
    CorePower.perform(url, schedule, DateTime.now + 1.days)
  end
end
