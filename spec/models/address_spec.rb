require 'spec_helper'

describe Address do
  
  it 'should create a valid address' do
    address = FactoryGirl.build(:valid_address)
    address.save.should be_true
    address.errors[:lat].should be_empty
    address.errors[:lon].should be_empty
    address.lat.should_not be_nil
    address.lon.should_not be_nil
    address.timezone.should_not be_nil
  end

  it 'should create a valid address when lat and lon are there' do
    address = FactoryGirl.build(:valid_address_with_coordinates)
    address.save.should be_true
    address.errors[:lat].should be_empty
    address.errors[:lon].should be_empty
    address.lat.should_not be_nil
    address.lon.should_not be_nil
    address.timezone.should_not be_nil
  end

  it 'should not create an invalid address' do
    address = FactoryGirl.build(:invalid_address)
    address.save.should be_false
    address.errors[:lat].should_not be_empty
    address.errors[:lon].should_not be_empty
    address.lat.should be_nil
    address.lon.should be_nil
    address.timezone.should be_nil
  end
end
