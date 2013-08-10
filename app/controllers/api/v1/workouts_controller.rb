require 'braintree'

module Api
  module V1
    class WorkoutsController < ApplicationController
      
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
        result = Braintree::Transaction.sale(
          :amount => "100.00",
          :credit_card => {
            :number => params[:encrypted_card_number],
            :expiration_month => params[:encrypted_expiration_month],
            :expiration_year => params[:encrypted_expiration_year],
          },
          :options => {
            :venmo_sdk_session => params[:venmo_sdk_session]
          }
        )
=begin
        result = Braintree::Transaction.sale(
          :amount => params[:amount],
          :credit_card => {
            :number => params[:cc_num],
            :expiration_date => params[:exp_date]
          }
        )
=end
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
    end
  end
end
