module Api
  module V1
    class PlacesController < ApplicationController
      
      respond_to :json

      # GET places/
      # Params: lat, lon. Optional Params: auth_token, q, radius
      # Returns array of place around you (default: cincinnati)
      def index
        if params[:page].nil?
          page = 1
        else
          page = params[:page]
        end
        @places = Place.get_nearby_places(params[:lat], params[:lon]).paginate(:page => page)
        render :json => 
            { 
              :places => @places.as_json(:list => true),
              :page_info => 
                { 
                  :page => page,
                  :per_page => Place.per_page,
                  :total_entries => @places.total_entries
                }
            }
      end
      
      def show
        @place = Place.where(:id => params[:id]).first
        if @place.nil?
          render :json => { :error => "Could not find place with id, #{params[:id]}" }
        else
          render :json => @place.as_json(:detail => true)
        end
      end

      def favorite
        @place = Place.where(:id => params[:id]).first
        if @place.nil?
          render :json => { :code => 2, :message => "Could not find place" }
        else
          @favorite = FavoritePlace.where(:user_id => current_user.id, :place_id => params[:id]).first
          if @favorite.nil?
            @favorite = FavoritePlace.create(:user_id => current_user.id, :place_id => params[:id])
            render :json => { :code => 1, :favorite => @favorite.as_json }
          else
            @favorite.destroy
            render :json => { :code => 0, :message =>  "Successfully deleleted"  }
          end
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
