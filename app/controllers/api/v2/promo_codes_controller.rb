module Api
  module V2
    class PromoCodesController < ApplicationController
      
      before_filter :authenticate_user!, :only => [ :create ]

      respond_to :json

      def create
        code = params[:promo_code]

        code = code.gsub("-", "")
        
        if (!code.nil?)
          promo_code = PromoCode.where("upper(code) = ?", code.upcase).first
        end

        if promo_code.instance_of?(InvitationCode)
          redeem_normal_code(promo_code)    
        elsif promo_code.instance_of?(PromoCode)
          redeem_invite_code(promo_code)
        else
          render :json => { :error => "Could not find promo code" }
        end
      end
    
      private

      def redeem_normal_code(promo_code)
        promo_count = promo_code.credits.count
        if promo_count >= promo_code.quantity
          render :json => { :error => "Promo code has already been used" }
        else            
          if (promo_code.credits.where(:user_id => current_user.id).count > 0)
            render :json => { :error => "You have already used this promo code" }
          else
            if !promo_code.random_promo.nil?
              redeem_random_code(promo_code)
            else
              credit = promo_code.credits.create(:user_id => current_user.id)
              render :json => { :user => current_user.as_json(:auth => true) }
            end
          end
        end
      end

      def redeem_random_code(promo_code)
        random_number = promo_code.random_promo * 100
        r = Random.new
        random = r.rand(100)
        if (random_number > random)
          credit = promo_code.credits.create(:user_id => current_user.id) 
          render :json => { :user => current_user.as_json(:auth => true) }
        else
          credit = promo_code.credits.create(:user_id => current_user.id, :total => 0)
          render :json => { :error => "Sorry, you did not win. Thanks for playing! Follow us on twitter and facebook for more chances to win!" }
        end
      end

      def redeem_invite_code(promo_code)

        if (promo_code.credits.where(:user_id => current_user.id).count > 0)
          render :json => { :error => "Sorry, the code you entered is only for new users" }
        else
          if (Receipt.where(:user_id => current_user.id).count > 0)
            render :json => { :error => "Sorry, the code you entered is only for new users" }
          else
            if (promo_code.user_id == current_user.id)
              render :json => { :error => "Sorry, can not use your own invitation code" }
            else
              promo_code.create(:user_id => current_user.id)
              render :json => { :user => current_user.as_json(:auth => true) }
            end
          end
        end
      end

    end
  end
end 
