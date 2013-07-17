module Api
  module V1
    class RatingsController < ApplicationController
      
      before_filter :authenticate_user!, :only => [ :create ]

      def show

      end

      def index
        @place = check_place(params[:place_id])
        if params[:reviews]
          @ratings = @place.ratings.reviews
        else
          @ratings = @place.ratings
        end
        @ratings.paginate(:page => get_page)
        render :json => 
          { 
            :ratings => @ratings.as_json,
            :page_info => 
              {
                :page => get_page,
                :per_page => Rating.per_page,
                :total_entries => @ratings.count
              }
          }
      end

      def create
        check_place(params[:place_id])
        @rating = current_user.write_review_for_place(rating_params, params[:place_id])
        if @rating.valid?
          @rating.save
          render :json => @rating.as_json
        else
          render :json => { :errors => @rating.errors }
        end
      end

      def update

      end
      
      def destroy

      end

      private

      def rating_params
        params.require(:rating).permit(:rating, :review)
      end
    end
  end
end

