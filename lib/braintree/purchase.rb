require 'braintree'

module Purchase
   
  # Purchase Workout - 
  #   @user - current_user
  #   @workout_id - workout.id
  #   @payment_code - venmo_sdk_payment_method_code
  #   ----
  #   returns hash:
  #     if error, hash contains, ":success => false"
  #     otherwise, hash contains, ":success => true"
  def self.buy_workout(user, workout_id)
    return_hash = {}
    # Default value for success
    return_hash[:success] = false

    if !user.has_payment_info?
      return_hash[:error] = "User has no credit card saved"
      return return_hash
    end

    workout = Workout.where(:id => workout_id).first
    if workout.nil?
      return_hash[:error] = "Workout with id, #{workout_id}, is nil"
    elsif workout.can_buy.nil? || !workout.can_buy
      return_hash[:error] = "Can't buy workout with id, #{workout_id}"
    elsif !workout.quantity_left.nil? && workout.quantity_left < 1
      return_hash[:error] = "No more passes left for the workout with id: #{workout_id}"
    else
      
      price = workout.price

      if (user.credit_amount >= price)
        Resque.enqueue(AddCreditsToInvitor, user.id, Receipt.where(:user_id => user.id).count)
        receipt = workout.buy_workout(user)
        user.use_credits(price)
        return_hash[:success] = true
        return_hash[:card_number] = "Credits Used"
        return_hash[:credit_card_type] = "credits"
        return_hash[:receipt] = receipt
        return return_hash
      elsif (user.credit_amount > 0)
        price = price - user.credit_amount
        Resque.enqueue(AddCreditsToInvitor, user.id, Receipt.where(:user_id => user.id).count)
        user.use_credits(user.credit_amount)
      end
      result = Braintree::Transaction.sale(
        :amount => price,
        :customer_id => user.braintree_customer_id,
        :options => {
          :submit_for_settlement => true
        }       
      )

      if result.success?
        receipt = workout.buy_workout(user)
        return_hash[:success] = true
        return_hash[:card_number] = result.transaction.credit_card_details.masked_number
        return_hash[:credit_card_type] = result.transaction.credit_card_details.card_type
        return_hash[:receipt] = receipt
      else
        return_hash[:error_message] = result.message
      end
    end
    return return_hash
  end

  def self.buy_package(user, package_id)
    return_hash = {}
    return_hash[:success] = false # default value

    if !user.has_payment_info?
      return_hash[:error] = "User has no credit card saved"
      return return_hash
    end 

    package = Package.where(:id => package_id).first
    if package.nil?
      return_hash[:error] = "Package with id: #{package_id}, is nil"
    else
      amount = package.discounted_amount
      
      result = Braintree::Transaction.sale(
        :amount => amount,
        :customer_id => user.braintree_customer_id,
        :options => {
          :submit_for_settlement => true
        }
      )

      if result.success?
        package.buy_package(user)
        user = User.find(user.id)
        return_hash[:success] = true
        return_hash[:card_number] = result.transaction.credit_card_details.masked_number
        return_hash[:credit_card_type] = result.transaction.credit_card_details.card_type
        return_hash[:total_credits] = user.credit_amount
      else
        return_hash[:error] = result.message
      end
    end
    return return_hash
  end
end
