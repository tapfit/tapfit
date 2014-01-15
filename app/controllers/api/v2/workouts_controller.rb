require 'braintree'
require './lib/braintree/purchase'

module Api
  module V2
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
        json = Purchase.buy_workout(current_user, params[:id])
        
        if json[:success] == false
          render :json => json, :status => 422
        else
          render :json => json
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
