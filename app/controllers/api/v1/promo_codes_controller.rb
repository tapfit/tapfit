module Api
  module V1
    class PromoCodesController < ApplicationController
      
      before_filter :authenticate_user!, :only => [ :create ]

      respond_to :json

      def create
        code = params[:promo_code]
        
        if (!code.nil?)
          promo_code = PromoCode.where("upper(code) = ?", code.upcase).first
        end

        if promo_code.nil?
          render :json => { :error => "Could not find promo code" }
        else
          promo_count = Credit.where(:promo_code_id => promo_code.id).count
          puts "promo count: #{promo_count}"
          if promo_count >= promo_code.quantity
            render :json => { :error => "Promo code has already been used" }
          else            
            if (Credit.where(:promo_code_id => promo_code.id, :user_id => current_user.id).count > 0)
              render :json => { :error => "You have already used this promo code" }
            else
              credit = Credit.create(:total => promo_code.amount, :user_id => current_user.id, :promo_code_id => promo_code.id)
              render :json => { :user => current_user.as_json(:auth => true) }
            end
          end
        end
      end 

    end
  end
end 
