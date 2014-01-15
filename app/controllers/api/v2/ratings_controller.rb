module Api
  module V2
    class RatingsController < ApplicationController
      
      before_filter :check_non_guest, :only => [ :create ]

      def show
        if check_place(params[:place_id]).nil?
          return
        end
        @rating = Rating.where(:id => params[:id]).first
        if @rating.nil?
          render :json => { :errors => "Couldn't find rating with id: #{params[:id]}" }
        else
          render :json => { :rating => @rating.as_json(:detail => true) }
        end
      end

      def index
        @workout = Workout.where(:id => params[:workout_id]).first
        if !@workout.nil?
          if params[:reviews]
            @ratings = @workout.ratings.reviews
          else
            @ratings = @workout.ratings
          end
        else
          @place = check_place(params[:place_id])
          if @place.nil?
            return
          end
          if params[:reviews]
            @ratings = @place.ratings.reviews
          else
            @ratings = @place.ratings
          end
        end
        @ratings.paginate(:page => get_page)
        render :json => 
          { 
            :ratings => @ratings.as_json(:list => true),
            :page_info => 
              {
                :page => get_page,
                :per_page => Rating.per_page,
                :total_entries => @ratings.count
              }
          }
      end

      def create
        if !params[:workout_id].nil?
          @workout = Workout.where(:id => params[:workout_id]).first
          if @workout.nil?
            render :json => { :errors => "Could not find workout with id: #{params[:workout_id]}" } and return
          else
            @rating = current_user.write_review_for_workout(rating_params, @workout)
          end
        else
          if check_place(params[:place_id]).nil?
            return
          end
          @rating = current_user.write_review_for_place(rating_params, params[:place_id])
        end
        if @rating.valid?
          @rating.save
          render :json => @rating.as_json(:list => true)
        else
          render :json => { :errors => @rating.errors }
        end
      end

      def update

      end
      
      def destroy
        if check_place(params[:place_id]).nil?
          return
        end
        @rating = Rating.where(:id => params[:id], :user_id => current_user.id).first
        if @rating.nil?
          render :json => { :errors => "Could not find rating for user, #{current_user.id}, and rating, #{params[:id]}" }
        else
          @rating.destroy
          render :json => { :success => true }
        end
      end

      private

      def rating_params
        params.require(:rating).permit(:rating, :review)
      end
    end
  end
end

