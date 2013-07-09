require 'uri'

class ProcessBase

  attr_accessor :name, :address, :tags, :url, :photo_url, :phone_number, :source_description, :source, :source_id, :start_time, :end_time, :price, :instructor

  @ten_digits = /^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/
  @seven_digits = /^(?:\(?([0-9]{3})\)?[-. ]?)?([0-9]{3})[-. ]?([0-9]{4})$/
  @leading_1 = /^(?:\+?1[-. ]?)?\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/
  @valid_keys = []

  def validate_crawler_values?(source_name)
    failed_processing = false  

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
      if !check_price?
        MailerUtils.write_error("price", @price, source_name)
        failed_processing = true
        puts "failed price"
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

    return failed_processing
  end

  def check_price?
    @price = @price.gsub("$", "")
    return @price.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true 
  end
  def check_time?(time)
    begin 
      Date.parse(time)
      return true
    rescue
      return false
    end
  end

  def check_name?(name)
    special = "?<>,?[]}{=)(*^%$#`~{}"
    regex = /[#{special.gsub(/./){|char| "\\#{char}"}}]/
    return !name.nil? && !(name =~ regex)
  end

  def check_address?
    if @address.nil?
      return false
    end
    address_string = @address[:line1] + @address[:city] + @address[:state] + @address[:zip]
    coordinates = Geocoder.coordinates(address_string)
    Rails.logger.debug "coordinates: #{coordinates}"
    if coordinates.nil?
      return false
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
      digits_only = @phone_number.gsub(/[^\d]/, '')
      if digits_only.length >= 10 && digits_only.length <=11
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def check_source_description?
    special = "?<>[]}{=)(*^$`~{}"
    regex = /[#{special.gsub(/./){|char| "\\#{char}"}}]/
    return !@source_description.nil? && !(@source_description =~ regex)
  end

  def check_if_nil?(source)
    return !source.nil?
  end

end