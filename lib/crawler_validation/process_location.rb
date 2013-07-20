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
      @dropin_price = opts[:dropin_price]
      @source = opts[:source]
      @source_id = opts[:source_id]
    end
  end

  def self.controller_helper(place, address, tags, source_id)
    
    
    opts = {}
    opts[:name] = place[:name] if !place[:name].nil?
    opts[:address] = address if !address.nil?
    opts[:tags] = tags if !tags.nil?
    opts[:url] = place[:url] if !place[:url].nil?
    opts[:phone_number] = place[:phone_number] if !place[:phone_number].nil?
    opts[:source_description] = place[:source_description] if !place[:source_description].nil?
    opts[:dropin_price] = place[:dropin_price] if !place[:dropin_price].nil?
    opts[:source] = place[:source] if !place[:source].nil?
    opts[:source_id] = source_id if !source_id.nil?
    process_location = ProcessLocation.new(opts)
    process_location.save_to_database(place[:source])
  end

  def save_to_database(source_name)
    if validate_crawler_values?(source_name)
      puts "failed to validate location"
    else
      address = Address.create(:line1 => @address[:line1], :line2 => @address[:line2], :city => @address[:city], :state => @address[:state], :zip => @address[:zip], :lat => @address[:latitude], :lon => @address[:longitude])
     
      if @source_id.nil?
        @source_id = "#{@source}/#{@name}"
      end

      place = Place.new(:name => @name, :address_id => address.id, :source => @source, :source_key => Digest::SHA1.hexdigest(@source_id.to_s), :url => @url, :phone_number => @phone_number, :source_description => @source_description, :is_public => true, :can_dropin => true, :dropin_price => @dropin_price)

      if place.save
        puts "saved to database: #{place.attributes}"
        if !@tags.nil?
          @tags.each do |tag|
            place.category_list.add(tag)
            place.save
          end
        end

        return place.id
      else
        puts "failed to save #{place.errors}"
        return nil
      end
    end
  end

  def self.get_place_id(source, source_id)
    place = Place.where(:source => source, :source_key => Digest::SHA1.hexdigest(source_id.to_s))
    if place.count > 0
      return place.first.id
    else
      return nil
    end
  end
end
