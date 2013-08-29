class Workout < ActiveRecord::Base
  
  belongs_to :instructor
  belongs_to :place
  has_one :address, :through => :place
  has_many :receipts

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

      BuyNotificationMailer.send_buy_email(receipt).deliver 

      return receipt
    end   
  end

  def as_json(options={})
    if !options[:place].nil?
      except_array ||= [ :instructor_id, :place_id, :source_description, :workout_key, :source, :price, :updated_at ]
      options[:include] ||= [ :instructor ]
    elsif !options[:detail].nil?      
      except_array ||= [ :updated_at, :workout_key, :source ]
      options[:include] ||= [ :instructor ]
      options[:method] ||= [ :quantity_left ]
    end
    options[:except] ||= except_array
    super(options)
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

end
