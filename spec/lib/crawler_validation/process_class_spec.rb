require 'spec_helper'

describe ProcessClass do

  before(:each) do
    @process_class = ProcessClass.new(:name => "Yoga Class", :tags => ["yoga"], :source => "goRecess", :source_id => "16854", :source_description => "Fun Yoga Class", :instructor => "Meg", :price => "$25.00", :start_time => "07/11/2013 9:00:00", :end_time => "07/11/2013 10:00:00")
    @empty_class = ProcessClass.new()
  end

  before(:each) do
    REDIS.del(MailerUtils.redis_key)
  end

  it 'should validate valid gyms info' do
    not_valid = @process_class.validate_crawler_values?("goRecess")
    #MailerUtils.send_error_email
    REDIS.lpop(MailerUtils.redis_key).should eql("")
    not_valid.should be_false
    REDIS.llen(MailerUtils.redis_key).should eql(0) 
  end

  it 'should validate empty gym' do
    @empty_class.validate_crawler_values?("goRecess").should be_false
    REDIS.llen(MailerUtils.redis_key).should eql(1)
  end

  it 'should not validate an invalid gym' do
    @process_class.name = "<p>"
    @process_class.address = nil
    @process_class.validate_crawler_values?("goRecess").should be_true
    REDIS.llen(MailerUtils.redis_key).should be_true
  end

end
