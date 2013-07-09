require_relative 'process_base'

class ProcessLocation < ProcessBase

  def initialize(opts={})
    if !opts.nil?
      @valid_keys = opts.keys
      @valid_keys = @valid_keys.collect{|i| i.to_s}
      @name = opts[:name]
      @address = opts[:address]
      @tags = opts[:tags]
      @url = opts[:url]
      @photo_url = opts[:photo_url]
      @phone_number = opts[:phone_number]
      @source_description = opts[:source_description]
      @source = opts[:source]
      @source_id = opts[:source_id]
    end
  end

  def save_to_database(source_name)
    if validate_crawler_values?
      puts "failed to validate location"
    else
      puts "saving to database: #{self.attributes}"
    end
  end

end
