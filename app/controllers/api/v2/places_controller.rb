module Api
  module V2
    class PlacesController < ApplicationController
      
      before_filter :check_non_guest, :only => [ :favorite, :checkin ]
      respond_to :json

      # GET places/
      # Params: lat, lon. Optional Params: auth_token, q, radius
      # Returns array of place around you (default: cincinnati)
      def index
        # @places = Place.get_nearby_places(params[:lat], params[:lon]).paginate(:page => get_page)
        # @places = Kaminari.paginate_array(Place.get_nearby_places(params[:lat], params[:lon], params[:radius], params[:q])).page(get_page)
        @places = Place.get_nearby_places(params[:lat], params[:lon], params[:radius], params[:q])
        render :json => 
            { 
              :places => @places
=begin
              :page_info => 
                { 
                  :page => get_page,
                  :per_page => Place.per_page,
                  :total_entries => @places.total_count 
                }
=end
            }
      end
      
      def show
        @place = check_place(params[:id])
        if @place.nil?
          return
        end

        render :json => @place.as_json(:detail => true)
      end

      def search
        lat = params[:lat].to_f
        lon = params[:lon].to_f
        @places = Place.joins(:address).where("UPPER(name) LIKE ?", "%#{params[:q].to_s.upcase}%")
          .where("lat BETWEEN ? AND ?", lat - 1, lat + 1)
          .where("lon BETWEEN ? AND ?", lon - 1, lon + 1)
        render :json => @places.as_json(:search => true)
      end

      def favorite
        if check_place(params[:id]).nil?
          return
        end        
        @favorite = FavoritePlace.where(:user_id => current_user.id, :place_id => params[:id]).first
        if @favorite.nil?
          @favorite = FavoritePlace.create(:user_id => current_user.id, :place_id => params[:id])
          render :json => { :success_code => 1 }
        else
          @favorite.destroy
          render :json => { :success_code => 0 }
        end
      end

      def checkin
        if check_place(params[:id]).nil?
          return
        end
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
