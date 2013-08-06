require 'spec_helper'

describe ProcessClass do

  before(:each) do
    @place = FactoryGirl.create(:place)
    @address = FactoryGirl.create(:valid_address_with_coordinates)
    @place.address = @address
    @place.save
    @opts = { :name => "Yoga Class", :tags => ["yoga"], :source => "goRecess", :source_id => "16854", :source_description => "Fun Yoga Class", :instructor => "Meg", :price => "$25.00", :start_time => DateTime.parse("11/07/2013 9:00:00"), :end_time => DateTime.parse("11/07/2013 10:00:00"), :place_id => @place.id }
    @process_class = ProcessClass.new(@opts)
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

  it 'should change time to UTC' do
    date = DateTime.now.beginning_of_day.advance(:hours => 10)
    date = ProcessClass.new().change_date_to_utc(date, "America/Chicago")
    date.should eql(DateTime.now.utc.beginning_of_day.advance(:hours => 6))
  end

  it 'should save a class to database' do
    @process_class.save_to_database("test")
    workout = Workout.all.first
    workout.start_time.should eql(@opts[:start_time])
    workout.end_time.should eql(@opts[:end_time])
  end

end
