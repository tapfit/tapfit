require 'braintree'

module Api
  module V1
    class WorkoutsController < ApplicationController
     
      before_filter :authenticate_user!, :only => [ :buy ] 
      respond_to :json

      def index
        @place = check_place(params[:place_id])
        if @place.instance_of?(Place) 
          @workouts = @place.todays_workouts
          render :json => @workouts.as_json(:detail => true)
        end
      end

      def show
        @workout = Workout.where(:id => params[:id]).first
        if @workout.nil?
          render :json => { :error => "Could not find workout" }
        else
          render :json => @workout.as_json(:detail => true)
        end
      end

      def buy
        if !user_signed_in?
          user = User.new(user_params)
          if user.valid?
            user.save
            sign_in(:user, user)
            user.ensure_authentication_token!
          else
            render :json => { :errors => user.errors }, :status => 420
            return
          end
        end

        if current_user.has_payment_info?

          result = Braintree::Transaction.sale(
            :credit_card => {
              :number => params[:card_number],
              :expiration_month => params[:expiration_month],
              :expiration_year= => params[:expiration_year]
            },
            :options => {
              :venmo_sdk_session => params
            } 
          )

          if result.success?
            current_user.braintree_customer_id = result.customer.id
          else
            render :json => { :errors => result.errors }, :status => 420
            return
          end
        end

        result = Braintree::Transaction.sale(
          :amount => "100.00",
          :customer_id => current_user.id,
          :venmo_sdk_payment_method_code => params[:venmo_sdk_payment_method_code]        
        )

        if result.success?
          render :json => response = {
            :success => true,
            :credit_card_number => result.transaction.credit_card_details.masked_number,
            :credit_card_type => result.transaction.credit_card_details.card_type
          }.to_json
        else
          render :json => response = {
            :success => false,
            :error_message => result.message
          }.to_json
        end
      end

      def create

      end

      def update

      end

      def delete

      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :first_name, :last_name)
      end

    end
  end
end
