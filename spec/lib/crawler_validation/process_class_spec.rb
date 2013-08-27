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
    date.utc.should eql(Time.now.utc.beginning_of_day.advance(:hours => 15))
  end

  it 'should save a class to database' do
    @process_class.save_to_database("test")
    workout = Workout.all.first
    DateTime.parse(workout.start_time.to_s).should eql((DateTime.parse(@opts[:start_time].to_s)).advance(:hours => 4).utc)
    DateTime.parse(workout.end_time.to_s).should eql((DateTime.parse(@opts[:end_time].to_s)).advance(:hours => 4).utc)
  end

  it 'should save an instrcutor' do
    @process_class.save_to_database("test")
    instructor = Instructor.all.first
    instructor.first_name.should eql(@opts[:instructor])
    instructor.last_name.should be_nil
  end

  it 'should not save duplicate instructors' do
    @process_class.save_to_database("test")
    @opts[:start_time] = DateTime.parse("11/07/2013 15:00:00")
    @opts[:end_time] = DateTime.parse("11/07/2013 16:00:00")
    process_class = ProcessClass.new(@opts)
    process_class.save_to_database("test")
    Instructor.all.count.should eql(1)
    instructor = Instructor.all.first
    instructor.first_name.should eql(@opts[:instructor])
    instructor.last_name.should be_nil
  end

  it 'should update class to old price' do
    @place.dropin_price = nil
    @place.save
    @process_class.save_to_database("test")
    price = 25
    @opts[:price] = 15
    @opts[:start_time] = DateTime.parse("11/07/2013 15:00:00")
    @opts[:end_time] = DateTime.parse("11/07/2013 16:00:00")
    process_class = ProcessClass.new(@opts)
    process_class.save_to_database("test")
    Workout.all.each do |workout|
      puts "workout.price: #{workout.price}"
    end
    Workout.where(:price => price).count.should eql(2)
  end

end
