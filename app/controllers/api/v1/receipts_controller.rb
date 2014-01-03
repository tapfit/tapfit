module Api
  module V1
    class ReceiptsController < ApplicationController
     
      before_filter :check_non_guest

      def index
        
        @receipts = Receipt.where(:user_id => current_user.id).paginate(:page => get_page, :per_page => 20)
        render :json => 
          { 
            :receipts => @receipts.as_json,
            :page_info =>
              {
                :page => get_page,
                :per_page => 20,
                :total_entries => @receipts.count
              } 
          }

      end  
      
      def show

        @receipt = Receipt.where(:user_id => current_user.id).where(:id => params[:id]).first
        if @receipt.nil?
          render :json => { :error => "Either receipt does not exist or receipt does not belong to user" }
        else
          render :json => @receipt.as_json
        end
        
      end

      def use
        
        @receipt = Receipt.where(:user_id => current_user.id, :id => params[:id]).first
        if @receipt.nil?
          render :json => { :error => "Either receipt does not exist or receipt does not belong to user." }
        else
          @receipt.has_used = true
          @receipt.save
          render :json => { :success => true }
        end
      end

    end
  end
end
