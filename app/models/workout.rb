class Workout < ActiveRecord::Base
  
  belongs_to :instructor
  belongs_to :place
  has_one :address, :through => :place
  has_many :receipts
  belongs_to :pass_detail

  def ratings
    return Rating.where(:workout_key => self.workout_key)
  end

  def buy_workout(user)
    if self.can_buy
      contract = self.place.place_contract
      if !contract.nil? && !contract.quantity.nil?
        if contract.quantity - self.place.passes_sold_today < 1
          return nil
        end
      end
      receipt_params = 
      {
        :place_id => self.place_id,
        :workout_id => self.id,
        :user_id => user.id,
        :workout_key => self.workout_key,
        :has_booked => false,
        :price => self.price 
      }

      receipt = Receipt.create(receipt_params)

      return receipt
    end   
  end

  def as_json(options={})
    
    if !options[:place].nil?
      except_array ||= [ :instructor_id, :place_id, :source_description, :workout_key, :source, :price, :updated_at, :pass_detail_id ]
      options[:include] ||= [ :instructor ]
    elsif !options[:detail].nil?      
      except_array ||= [ :updated_at, :workout_key, :source, :pass_detail_id ]
      options[:include] ||= [ :instructor ]
      options[:methods] ||= [ :quantity_left, :avg_rating, :fine_print ]
    elsif !options[:lean_list].nil?
      except_array ||= [ :instructor_id, :place_id, :source_description, :source, :is_bookable, :created_at, :updated_at, :can_buy, :is_day_pass, :is_cancelled, :pass_detail_id, :crawler_info ]
    end
    options[:except] ||= except_array
    super(options)
  end

  def fine_print
    pass_detail = self.pass_detail
    if pass_detail.nil?
      return nil
    else
      return pass_detail.fine_print
    end
  end

  def quantity_left
    if self.place.place_contract.nil?
      return nil
    else
      quantity = self.place.place_contract.quantity
      if quantity.nil?
        return nil
      else
        return quantity - self.place.passes_sold_today
      end
    end
  end

  def avg_rating
    return (self.ratings.count > 0) ? self.ratings.average(:rating).to_i : -1
  end

  def classId
    if self.crawler_info.nil?
      return nil
    else
      return self.crawler_info['classId']
    end
  end

  def paymentId
    if self.crawler_info.nil?
      return nil
    else
      return self.crawler_info['paymentId']
    end
  end

  def local_start_time
    return self.start_time.in_time_zone(self.place.address.timezone)
  end
end
