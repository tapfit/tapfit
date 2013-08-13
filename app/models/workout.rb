class Workout < ActiveRecord::Base
  
  belongs_to :instructor
  belongs_to :place
  has_one :address, :through => :place

  def buy_workout(user)
    if self.can_buy
          
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
      except_array ||= [ :instructor_id, :place_id, :source_description, :workout_key, :source, :price, :created_at, :updated_at ]
      options[:include] ||= [ :instructor ]
    elsif !options[:detail].nil?      
      except_array ||= [ :created_at, :updated_at, :workout_key, :source ]
      options[:include] ||= [ :instructor ]
    end
    options[:except] ||= except_array
    super(options)
  end
end
