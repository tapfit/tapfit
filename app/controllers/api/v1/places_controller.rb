module Api
  module V1
    class PlacesController < ApplicationController
      
      before_filter :authenticate_user!, :only => [ :favorite, :checkin ]
      respond_to :json

      # GET places/
      # Params: lat, lon. Optional Params: auth_token, q, radius
      # Returns array of place around you (default: cincinnati)
      def index
        # @places = Place.get_nearby_places(params[:lat], params[:lon]).paginate(:page => get_page)
        @places = Kaminari.paginate_array(Place.get_nearby_places(params[:lat], params[:lon], params[:radius], params[:q])).page(get_page)
        render :json => 
            { 
              :places => @places.as_json(:list => true),
              :page_info => 
                { 
                  :page => get_page,
                  :per_page => Place.per_page,
                  :total_entries => @places.total_count 
                }
            }
      end
      
      def show
        @place = check_place(params[:id])
        render :json => @place.as_json(:detail => true)
      end

      def favorite
        check_place(params[:id])        
        @favorite = FavoritePlace.where(:user_id => current_user.id, :place_id => params[:id]).first
        if @favorite.nil?
          @favorite = FavoritePlace.create(:user_id => current_user.id, :place_id => params[:id])
          render :json => { :code => 1, :favorite => @favorite.as_json }
        else
          @favorite.destroy
          render :json => { :code => 0, :message =>  "Successfully deleleted"  }
        end
      end

      def checkin
        check_place(params[:id])
        @checkin = Checkin.where(:user_id => current_user.id, :place_id => params[:id]).order("created_at DESC").first
        if @checkin.nil? || @checkin.created_at + 1.hours < Time.now  
          @checkin = Checkin.create(:user_id => current_user.id, :place_id => params[:id], :lat => params[:lat], :lon => params[:lon])
          render :json => { :code => 1, :checkin => @checkin.as_json }
        else
          render :json => { :code => 0, :message => "Already Checked In" }
        end
      end


      def create

      end

      def update

      end

      def destroy

      end

    end
  end
end
