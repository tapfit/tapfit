module Api
  module V1
    class WorkoutsController < ApplicationController
      
      respond_to :json

      def index
        @place = check_place(params[:place_id]) 
        @workouts = @place.workouts
        render :json => @workouts.as_json.as_json(:detail => true)
      end

      def show
        @workout = Workout.where(:id => params[:id]).first
        if @workout.nil?
          render :json => { :error => "Could not find workout" }
        else
          render :json => @workout.as_json(:detail => true)
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
