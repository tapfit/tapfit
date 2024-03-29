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
      @schedule_url = opts[:schedule_url]
      @category = opts[:category]
      @dropin_price = opts[:dropin_price]
      @source = opts[:source]
      @source_id = opts[:source_id]
      @can_buy = opts[:can_buy]
      @facility_type = opts[:facility_type]
      @crawler_source = opts[:crawler_source]
    end
  end

  def self.controller_helper(place, address)
    
    
    opts = {}
    opts[:name] = place[:name] if !place[:name].nil?
    opts[:address] = address if !address.nil?
    opts[:url] = place[:url] if !(place[:url].nil? || place[:url] == "")
    opts[:schedule_url] = place[:schedule_url] if !(place[:schedule_url].nil? || place[:schedule_url] == "")
    opts[:phone_number] = place[:phone_number] if !(place[:phone_number].nil? || place[:phone_number] == "")
    opts[:source_description] = place[:source_description] if !(place[:source_description].nil? || place[:source_description] == "")
    opts[:dropin_price] = place[:dropin_price] if !(place[:dropin_price].nil? || place[:dropin_price] == "")
    opts[:source] = place[:source] if !place[:source].nil?
    opts[:category] = place[:category]
    opts[:can_buy] = place[:can_buy]
    opts[:facility_type] = place[:facility_type]
    opts[:crawler_source] = place[:crawler_source]
    process_location = ProcessLocation.new(opts)
    return process_location.save_to_database(place[:source])
  end

  def save_to_database(source_name)
    if validate_crawler_values?(source_name)
      puts "failed to validate location"
    else
      address = Address.check_for_duplicate(@address)
      if address.nil?
        address = Address.create(@address)
      else
        place = Place.combine_place(address, self.attrs, @tags)
        if !place.nil?
          puts "same address found: #{place.name}"
          place.source_key = Digest::SHA1.hexdigest("#{@source}/#{place.name}")
          place.save
          return place.id
        end
      end

      if @source_id.nil?
        @source_id = "#{@source}/#{@name}"
      end
    
      place = Place.new(self.attrs)
      place.address_id = address.id
      place.is_public = true
      place.source_key = Digest::SHA1.hexdigest(@source_id.to_s)

      if place.save
        puts "saved to database: #{place.name}"
        if !@tags.nil?
          @tags.each do |tag|
            place.category_list.add(tag)
          end
          place.save
          if @category.nil?
            place.category = Category.get_category(@tags)
            place.save
            puts "Category: #{place.category}"
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
