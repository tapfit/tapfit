module Api
  module V1
    class PromoCodesController < ApplicationController
      
      before_filter :authenticate_user!, :only => [ :create ]

      respond_to :json

      def create
        code = params[:promo_code]

        promo_code = PromoCode.where(:code => code).first

        if promo_code.nil?
          render :json => { :error => "Could not find promo code" }
        else
          if promo_code.has_used
            render :json => { :error => "Promo code has already been used" }
          else
            credit = Credit.create(:total => promo_code.amount, :user_id => current_user.id, :promo_code_id => promo_code.id)
            promo_code.has_used = true
            promo_code.save 
            render :json => { :user => current_user.as_json(:auth => true) }
          end
        end
      end 

    end
  end
end 
