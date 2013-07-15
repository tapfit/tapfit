module Api
  module V1
    class WorkoutsController < ApplicationController
      
      respond_to :json

      def index
        place = Place.where(:id => params[:place_id]).first
        if place.nil?
          render :json => { :error => "Could not find place with id, #{params[:place_id]}" }
        else
          @workouts = place.workouts
          render :json => @workouts.as_json
        end
      end

      def show
        @workout = Workout.where(:id => params[:id]).first
        if @workout.nil?
          render :json => { :error => "Could not find workout" }
        else
          render :json => @workout.as_json
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
