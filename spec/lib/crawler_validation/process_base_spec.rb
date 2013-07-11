require 'spec_helper'

describe ProcessBase do

  before(:each) do
    @process_base = ProcessBase.new
  end

  it 'should return true for phone number with letters' do
    @process_base.phone_number = "513276YOGA"
    @process_base.check_phone_number?.should be_true
  end
end
