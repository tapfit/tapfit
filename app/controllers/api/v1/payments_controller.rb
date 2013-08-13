module Api
  module V1
    class PaymentsController < ApplicationController

      before_filter :check_braintree
      respond_to :json

      def create

        result = Braintree::CreditCard.create(
          :customer_id => current_user.braintree_customer_id,
          :number => params[:credit_card],
          :expiration_month => params[:expiration_month],
          :expiration_year => params[:expiration_year],
          :options => {
            :venmo_sdk_session => params[:venmo_sdk_session]
          }
        )

        if result.success?
          render :json => { 
            :success => true
          }
        else
          render :json => { :success => false, :error_message => result.message }, :status => 422
        end
      end

      def usecard

        result = Braintree::CreditCard.create(
          :customer_id => current_user.braintree_customer_id,
          :venmo_sdk_payment_method_code => params[:venmo_sdk_payment_method_code],
        )

        if result.success?
          render :json => {
            :success => true
          }
        else
          render :json => {
            :success => false,
            :error_message => result.message
          }, :status => 422
        end
      end

      private

      def check_braintree
        check_non_guest
        if !current_user.has_payment_info?
          result = Braintree::Customer.create(
            :first_name => current_user.first_name,
            :last_name => current_user.last_name
          )
          if result.success?
            current_user.braintree_customer_id = result.customer.id
            current_user.save
          else
            render :json => 
            {
              :success => false,
              :error_message => result.message
            }, :status => 422 and return
          end
        end
      end
    end
  end
end