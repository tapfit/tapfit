require 'spec_helper'

describe ProcessBase do

  before(:each) do
    @process_base = ProcessBase.new
  end

  it 'should return true for phone number with letters' do
    @process_base.phone_number = "513276YOGA"
    @process_base.check_phone_number?.should be_true
  end

  it 'should return true for price' do
    @process_base.check_price?("$18.00").should be_true
  end

  it 'should return false for time' do
    time = "07/11/2013 10:00:00"
    @process_base.check_time?(time).should be_false
  end
end
