require 'spec_helper'
require 'uri'

describe ProcessLocation do

  before(:each) do
    @process_location = ProcessLocation.new(:name => "My Gym", :address => {:line1 => "1507 N Hudson Ave", :city => "Chicago", :state => "IL", :zip => "60610"}, :tags => ["yoga", "crossfit"], :phone_number => "+1 (937)-776-3643", :source => "goRecess", :source_id => "16854")
    @empty_location = ProcessLocation.new()
  end

  before(:each) do
    REDIS.del(MailerUtils.redis_key)
  end

  it 'should validate valid gyms info' do
    not_valid = @process_location.validate_crawler_values?("goRecess")
    MailerUtils.send_error_email
    not_valid.should be_false
    REDIS.exists(MailerUtils.redis_key).should be_false
  end

  it 'should validate empty gym' do
    @empty_location.validate_crawler_values?("goRecess").should be_false
    REDIS.exists(MailerUtils.redis_key).should be_false
  end

  it 'should not validate an invalid gym' do
    @process_location.name = "<p>"
    @process_location.address = nil
    @process_location.validate_crawler_values?("goRecess").should be_true
    REDIS.llen(MailerUtils.redis_key).should be_true
  end
end
