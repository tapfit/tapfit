require 'spec_helper'

describe SyncAccountToTrackingSource, :job => true do

  before(:all) do
    @device_token = SecureRandom.hex
    @tracker = FactoryGirl.build(:tracking)
    @tracker.hexicode = @device_token
    @tracker.save
  end

  it 'should sync an account if there' do
    
  end

end
