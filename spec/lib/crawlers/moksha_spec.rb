require 'spec_helper'

describe Moksha do

  it 'should grab all studios for moksha' do
  
    Rails.logger = Logger.new(STDOUT)
    
    #Moksha.get_locations

    Place.where(:source => "moksha").each do |place|
      # Rails.logger.debug place.attributes
    end 
  end

  it 'should get schedule info' do
    
    place = FactoryGirl.build(:place)
    place.dropin_price = 15
    place.save

    Moksha.get_classes("http://minneapolis.mokshayoga.ca/", place.id, DateTime.now)

    Workout.where(:source => "moksha").each do |workout|
      # puts workout.attributes
      break
    end

  end

end
