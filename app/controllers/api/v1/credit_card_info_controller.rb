module Api
  module V1
    class CreditCardInfoController < ApplicationController

      before_filter :authenticate_user!
      respond_to :json

      def addcard
        if !current_user.has_payment_info?
          result = Braintree::Customer.create(
            :first_name => current_user.first_name,
            :last_name => current_user.last_name, 
            :email => current_user.email,
          )

          if result.success?
            
          else
            render :json => { :errors => result.errors }
          end
        else

        end
      end

    end
  end
end
