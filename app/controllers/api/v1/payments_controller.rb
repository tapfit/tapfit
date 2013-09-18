module Api
  module V1
    class PaymentsController < ApplicationController

      before_filter :check_braintree
      respond_to :json

      def create
        
        puts params

        result = Braintree::CreditCard.create(
          :customer_id => current_user.braintree_customer_id,
          :number => params[:card_number],
          :expiration_month => params[:expiration_month],
          :expiration_year => params[:expiration_year],
          :options => {
            :venmo_sdk_session => params[:venmo_sdk_session],
            :make_default => true
          }
        )

        token = nil
        last_four = nil
        card_type = nil
        image_url = nil



        customer = get_braintree_customer
        customer.credit_cards.each do |cc|
          if cc.default?
            token = cc.token
            last_four = cc.last_4
            card_type = cc.card_type
            image_url = cc.image_url
            break
          end
        end

        if result.success?
          render :json => { 
            :success => true,
            :credit_card => token,
            :last_four => last_four,
            :card_type => card_type,
            :image_url => image_url
          }
        else
          render :json => { :success => false, :error_message => result.message }, :status => 422
        end
      end

      def delete
        token = params[:token]

        result = Braintree::CreditCard.delete(token)

        token = nil

        customer = get_braintree_customer
        customer.credit_cards.each do |cc|
          if cc.default?
            token = cc.token
            break
          end
        end

        if result
          render :json => {
            :success => true,
            :default_card => token
          }
        else
          render :json => {
            :success => false
          }, :status => 422
        end
      end

      def default
        token = params[:token]
        result = Braintree::CreditCard.update(
          token,
          :options => {
            :make_default => true
          }
        )

        # customer = Braintree::Customer.find(current_user.id)

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

      def usecard

        result = Braintree::CreditCard.create(
          :customer_id => current_user.braintree_customer_id,
          :venmo_sdk_payment_method_code => params[:venmo_sdk_payment_method_code]
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

      def index
        
        default_token = nil
        braintree_customer = get_braintree_customer        
        braintree_customer.credit_cards.each do |cc|
          if cc.default?
            default_token = cc.token
            break
          end
        end

        card_info = []
        braintree_customer.credit_cards.each do |cc|
          card_info << { :token => cc.token, :last_four => cc.last_4, :card_type => cc.card_type, :image_url => cc.image_url }
        end

        render :json => { :credit_cards => card_info, :default => default_token }
      end

      private

      def check_braintree
        check_non_guest
        puts "has_payment_info: #{current_user.has_payment_info?}, braintree_id: #{current_user.braintree_customer_id}"
        if !current_user.has_payment_info?
          begin
            customer = Braintree::Customer.find(current_user.id)
            current_user.braintree_customer_id = current_user.id
            current_user.save
          rescue Braintree::NotFoundError => e
            result = Braintree::Customer.create(
              :first_name => current_user.first_name,
              :last_name => current_user.last_name,
              :id => current_user.id
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

      def get_braintree_customer
        begin
          customer = Braintree::Customer.find(current_user.id)
          current_user.braintree_customer_id = current_user.id
          current_user.save
          return customer
        rescue Braintree::NotFoundError => e
          result = Braintree::Customer.create(
            :first_name => current_user.first_name,
            :last_name => current_user.last_name,
            :id => current_user.id
          )
          if result.success?
            current_user.braintree_customer_id = result.customer.id
            current_user.save
            return result.customer
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
