require 'spec_helper'
require 'uri'

describe ProcessLocation do

  before(:each) do
    @opts = {:name => "My Gym", :address => {:line1 => "1507 N Hudson Ave", :city => "Chicago", :state => "IL", :zip => "60610"}, :tags => ["yoga", "crossfit"], :phone_number => "+1 (937)-776-3643", :source => "goRecess", :source_id => "16854", :url => "http://www.google.com" }
    @process_location = ProcessLocation.new(@opts)
    @empty_location = ProcessLocation.new()
  end

  before(:each) do
    REDIS.del(MailerUtils.redis_key)
  end

  it 'should validate valid gyms info' do
    not_valid = @process_location.validate_crawler_values?("goRecess")
    MailerUtils.send_error_email
    not_valid.should be_false
    REDIS.llen(MailerUtils.redis_key).should eql(0)
  end

  it 'should validate empty gym' do
    @empty_location.validate_crawler_values?("goRecess").should be_false
    REDIS.llen(MailerUtils.redis_key).should eql(1)
  end

  it 'should not validate an invalid gym' do
    @process_location.name = "<p>"
    @process_location.address = nil
    @process_location.validate_crawler_values?("goRecess").should be_true
    REDIS.llen(MailerUtils.redis_key).should be_true
  end

  it 'should save a gym to the database' do
    count = Place.all.count

    @process_location.save_to_database("test")

    Place.all.count.should eql(count + 1)
    place = Place.all.first

    place.name.should eql(@opts[:name])
    place.source_key.should eql(Digest::SHA1.hexdigest(@opts[:source_id]))
    place.url.should eql(@opts[:url])
    place.category_list.sort.should eql(@opts[:tags].sort.map { |p| p.capitalize })
    place.phone_number.should eql(@opts[:phone_number])
    puts count
  end
end
