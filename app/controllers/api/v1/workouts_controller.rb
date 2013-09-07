require 'braintree'

module Api
  module V1
    class WorkoutsController < ApplicationController
     
      before_filter :check_non_guest, :only => [ :buy ] 
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
        
        if !current_user.has_payment_info?
          render :json => { :error => "User has no credit card saved" }, :status => 422 and return
        end

        @workout = Workout.where(:id => params[:id]).first
        # puts "can_buy: #{@workout.can_buy}"
        if @workout.nil?
          render :json => { :error => "Workout with id, #{params[:id]}, is nil" }, :status => 422
        elsif @workout.can_buy.nil? || !@workout.can_buy
          render :json => { :error => "Can't buy workout with id, #{params[:id]}" }, :status => 422
        elsif !@workout.quantity_left.nil? && @workout.quantity_left < 1
          render :json => { :error => "No more passes left for the workout with id: #{params[:id]}" }, :status => 422
        else

          result = Braintree::Transaction.sale(
            :amount => @workout.price,
            :customer_id => current_user.braintree_customer_id,
            :venmo_sdk_payment_method_code => params[:venmo_sdk_payment_method_code]        
          )

          if result.success?
            receipt = @workout.buy_workout(current_user)
            render :json => {
              :success => true,
              :card_number => result.transaction.credit_card_details.masked_number,
              :credit_card_type => result.transaction.credit_card_details.card_type,
              :receipt => receipt
            }
          else
            render :json => {
              :success => false,
              :error_message => result.message
            }, :status => 422
          end
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
