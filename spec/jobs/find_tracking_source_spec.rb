require 'spec_helper'

describe FindTrackingSource, :job => true do

  before(:all) do
    @opts = {}
    @opts[:device_token] = SecureRandom.hex
    @opts[:device] = "Android"
    @opts[:ip_address] = "1.2.3.4"
  end

  it 'links tracking for same ip' do
    tracker = FactoryGirl.build(:tracking)
    tracker.ip_address = "1.2.3.4"
    tracker.save
    
    sleep(1)
    FindTrackingSource.new.perform(@opts)
    tracker.reload
    tracker.hexicode.should eql(@opts[:device_token])
  end

  it 'links tracking for same ip with multiple tracking only one source' do
    tracker = FactoryGirl.build(:tracking)
    tracker.ip_address = @opts[:ip_address]
    tracker.utm_source = "Facebook"
    tracker.save

    tracker1 = FactoryGirl.build(:tracking)
    tracker1.ip_address = @opts[:ip_address]
    tracker1.utm_source = "Facebook"
    tracker1.save

    sleep(1)

    FindTrackingSource.new.perform(@opts).should be_nil
    tracker.reload
    tracker.hexicode.should eql(@opts[:device_token])

    @opts[:device_token] = SecureRandom.hex
    FindTrackingSource.new.perform(@opts).should be_nil
    tracker1.reload
    tracker1.hexicode.should eql(@opts[:device_token])

    @opts[:device_token] = SecureRandom.hex
    FindTrackingSource.new.perform(@opts).should_not be_nil
  end

  it 'doesnt link tracking for same ip with multiple tracking multiple source' do
    tracker = FactoryGirl.build(:tracking)
    tracker.ip_address = @opts[:ip_address]
    tracker.utm_source = "Twitter"
    tracker.save

    tracker1 = FactoryGirl.build(:tracking)
    tracker1.ip_address = @opts[:ip_address]
    tracker1.utm_source = "Facebook"
    tracker1.save

    sleep(1)

    FindTrackingSource.new.perform(@opts)
    Tracking.where("hexicode IS NOT NULL").count.should eql(0)

  end

  it 'links iphone download with tracking' do
    @opts[:device] = "iPhone"
    tracker = FactoryGirl.build(:tracking)
    tracker.download_iphone = true
    tracker.save

    sleep(1)

    FindTrackingSource.new.perform(@opts)
    tracker.reload
    tracker.hexicode.should eql(@opts[:device_token])
  end

  it 'links iphone download with multiple tracking, same source' do
    @opts[:device] = "iPhone"
    tracker = FactoryGirl.build(:tracking)
    tracker.download_iphone = true
    tracker.save

    tracker1 = FactoryGirl.build(:tracking)
    tracker1.download_iphone = true
    tracker1.save

    sleep(1)

    FindTrackingSource.new.perform(@opts)
    tracker.reload
    tracker.hexicode.should eql(@opts[:device_token])

    @opts[:device_token] = SecureRandom.hex
    FindTrackingSource.new.perform(@opts)
    tracker1.reload
    tracker1.hexicode.should eql(@opts[:device_token])

    @opts[:device_token] = SecureRandom.hex
    FindTrackingSource.new.perform(@opts).should_not be_nil
  end

  it 'doesnt link iphone download with multiple tracking, different sources' do
    @opts[:device] = "iPhone"
    tracker = FactoryGirl.build(:tracking)
    tracker.download_iphone = true
    tracker.utm_source = "Facebook"
    tracker.save

    tracker1 = FactoryGirl.build(:tracking)
    tracker1.download_iphone = true
    tracker1.utm_source = "Twitter"
    tracker1.save

    sleep(1)

    FindTrackingSource.new.perform(@opts).should_not be_nil
  end

  it 'links android download with tracking' do
    @opts[:device] = "Android"
    tracker = FactoryGirl.build(:tracking)
    tracker.download_android = true
    tracker.save

    sleep(1)

    FindTrackingSource.new.perform(@opts)
    tracker.reload
    tracker.hexicode.should eql(@opts[:device_token])
  end

  it 'links andorid download with multiple tracking, same source' do
    @opts[:device] = "Android"
    tracker = FactoryGirl.build(:tracking)
    tracker.download_android = true
    tracker.save

    tracker1 = FactoryGirl.build(:tracking)
    tracker1.download_android = true
    tracker1.save

    sleep(1)

    FindTrackingSource.new.perform(@opts)
    tracker.reload
    tracker.hexicode.should eql(@opts[:device_token])

    @opts[:device_token] = SecureRandom.hex
    FindTrackingSource.new.perform(@opts)
    tracker1.reload
    tracker1.hexicode.should eql(@opts[:device_token])

    @opts[:device_token] = SecureRandom.hex
    FindTrackingSource.new.perform(@opts).should_not be_nil
  end

  it 'doesnt link iphone download with multiple tracking, different sources' do
    @opts[:device] = "Android"
    tracker = FactoryGirl.build(:tracking)
    tracker.download_android = true
    tracker.utm_source = "Facebook"
    tracker.save

    tracker1 = FactoryGirl.build(:tracking)
    tracker1.download_android = true
    tracker1.utm_source = "Twitter"
    tracker1.save

    sleep(1)

    FindTrackingSource.new.perform(@opts).should_not be_nil
  end
end
