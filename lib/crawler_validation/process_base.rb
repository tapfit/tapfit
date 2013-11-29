require 'uri'
require './lib/letter_to_phone_number'
require './lib/crawler_validation/mailer_utils'
require './lib/category'

class ProcessBase

  attr_accessor :name, :address, :tags, :url, :photo_url, :phone_number, :source_description, :source, :source_id, :start_time, :end_time, :price, :instructor, :place_id, :dropin_price, :schedule_url, :category, :can_buy, :is_day_pass, :is_cancelled, :facility_type, :crawler_source, :class_id

  @ten_digits = /^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/
  @seven_digits = /^(?:\(?([0-9]{3})\)?[-. ]?)?([0-9]{3})[-. ]?([0-9]{4})$/
  @leading_1 = /^(?:\+?1[-. ]?)?\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/
  @valid_keys = []

  def attrs
    hash = {}
    self.instance_variables.each do |var|
      if var.to_s != "@ten_digits" && var.to_s != "@seven_digits" && var.to_s != "@leading_1" && var.to_s != "@valid_keys" && var.to_s != "@tags" && var.to_s != "@address" && var.to_s != "@photo_url" && var.to_s != "@source_id"
        hash[var.to_s.delete("@")] = self.instance_variable_get(var)
      end
    end
    puts hash
    return hash  
  end

  def validate_crawler_values?(source_name)
    failed_processing = false  

    if @valid_keys.include?("schedule_url")
      if !check_url?(@schedule_url)
        MailerUtils.write_error("schedule_url", @schedule_url, source_name)
        failed_processing = true
        puts "failed schedule_url"
      end
    end

    if @valid_keys.include?("dropin_price")
      if !check_price?(@dropin_price)
        MailerUtils.write_error("dropin_price", @dropin_price, source_name)
        failed_processing = true
        puts "failed dropin_price"
      else
        @dropin_price = @dropin_price.to_s.gsub(/[$A-Za-z ]/,"")
      end
    end

    if @valid_keys.include?("start_time")
      if !check_time?(@start_time)
        MailerUtils.write_error("start_time", @start_time, source_name)
        failed_processing = true
        puts "failed start_time"
      end
    end

    if @valid_keys.include?("end_time")
      if !check_time?(@end_time)
        MailerUtils.write_error("end_time", @end_time, source_name)
        failed_processing = true
        puts "failed end time"
      end
    end

    if @valid_keys.include?("price")
      if !check_price?(@price)
        MailerUtils.write_error("price", @price, "#{source_name} from place: #{@place_id}, for name: #{@name}")
        failed_processing = true
        puts "failed price"
      else
        @price = @price.to_s.gsub(/[$A-Za-z ]/,"")
      end
    end

    if @valid_keys.include?("instructor")
      if !check_name?(@instructor)
        MailerUtils.write_error("instructor", @instructor, source_name)
        failed_processing = true
        puts "failed instructor"
      end
    end
      
    if @valid_keys.include?("name")
      if !check_name?(@name)
        MailerUtils.write_error("name", @name, source_name)
        failed_processing = true
        puts "failed name"
      end
    end

    if @valid_keys.include?("address")
      if !check_address?
        MailerUtils.write_error("address", @address, source_name)
        failed_processing = true
        puts "failed address"
      end
    end

    if @valid_keys.include?("tags")
      if !check_tags?
        MailerUtils.write_error("tags", @tags, source_name)
        failed_processing = true
        puts "failed tags"
      end
    end

    if @valid_keys.include?("url")
      if !check_url?(@url)
        MailerUtils.write_error("url", @url, source_name)
        failed_processing = true
        puts "failed url"
      end
    end

    if @valid_keys.include?("photo_url")
      if !check_url?(@photo_url)
        MailerUtils.write_error("photo_url", @photo_url, source_name)
        failed_processing = true
        puts "failed photo_url"
      end
    end

    if @valid_keys.include?("phone_number")
      if !check_phone_number?
        MailerUtils.write_error("phone_number", @phone_number, source_name)
        failed_processing = true
        puts "failed phone_number"
      end
    end

    if @valid_keys.include?("source_description")
      if !check_source_description?
        MailerUtils.write_error("source_description", @source_description, source_name)
        failed_processing = true
        puts "failed source_description"
      end
    end
    
    if @valid_keys.include?("source")
      if !check_if_nil?(@source)
        MailerUtils.write_error("source", @source_description, source_name)
        failed_processing = true
        puts "failed source"
      end
    end

    if @valid_keys.include?("source_id")
      if !check_if_nil?(@source_id)
        MailerUtils.write_error("source_id", @source_id, source_name)
        failed_processing = true
        puts "failed source_id"
      end
    end

    if !failed_processing
      REDIS.lpush(MailerUtils.redis_key, "")
    end
    return failed_processing
  end

  def check_price?(price)
    price = price.to_s.gsub(/[$A-Za-z \n\t\r]/, "").rstrip
    if price.nil? || price.empty?
      return true
    end
    return price.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true 
  end
  def check_time?(time)
    begin 
      puts time
      if time.instance_of?(Time) || time.instance_of?(DateTime)
        puts "instance of time or datetime"
        return true
      end
      parsed_time = Time.parse(time.to_s)
      puts parsed_time
      return true
    rescue => e
      puts "failed to process time" 
      return false
    end
  end

  def check_name?(name)
    special = "?<>[]}{{}"
    regex = /[#{special.gsub(/./){|char| "\\#{char}"}}]/
    return !name.nil? && !(name =~ regex)
  end

  def check_address?
    if @address.nil?
      return false
    end
    if @address[:line1].nil? || @address[:city].nil? || @address[:state].nil? || @address[:zip].nil?
      if @address[:lat].nil? || @address[:lon].nil?
        return false
      end
    end
    address_string = @address[:line1] + @address[:city] + @address[:state] + @address[:zip]
    if @address[:lat].nil? || @address[:lon].nil?
      coordinates = Geocoder.coordinates(address_string)
      puts "coordinates: #{coordinates}"
      if coordinates.nil?
        return false
      else      
        @address[:lat] = coordinates[0]
        @address[:lon] = coordinates[1]
        return true
      end
    else
      return true
    end
  end

  def check_tags?
    return !@tags.nil? && @tags.kind_of?(Array)
  end

  def check_url?(url)
    return !url.nil? && url =~ /^#{URI::regexp}$/
  end

  def check_phone_number?
    if !@phone_number.nil?
      if @phone_number.length > 20 || @phone_number.length < 7
        puts "failed length test"
        return false
      else
        @phone_number.split("").each do |char|
          if char =~ /[[:alpha:]]/
            integer = LetterToPhoneNumber.get_number_from_letter(char)
            if !integer.nil?
              puts "char: #{char}, integer: #{integer.to_s}"
              @phone_number = @phone_number.gsub(char, integer.to_s)
            end
          end
        end
        puts "phone_number: #{@phone_number}"
        digits_only = @phone_number.gsub(/[^\d]/, '')
        puts "digits_only: #{digits_only}"
        if digits_only.length >= 10 && digits_only.length <=11
          return true
        else
          return false
        end
      end
    else
      return false
    end
  end

  def check_source_description?
    special = "<>[]}{=*^`{}"
    regex = /[#{special.gsub(/./){|char| "\\#{char}"}}]/
    return !@source_description.nil? && !(@source_description =~ regex)
  end

  def check_if_nil?(source)
    return !source.nil?
  end

end
