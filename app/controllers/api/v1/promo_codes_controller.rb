module Api
  module V1
    class PromoCodesController < ApplicationController
      
      before_filter :authenticate_user!, :only => [ :create ]

      respond_to :json

      def create
        code = params[:promo_code]

        code = code.gsub("-", "")
        
        if (!code.nil?)
          promo_code = PromoCode.where("upper(code) = ?", code.upcase).first
        end

        if promo_code.nil?
          render :json => { :error => "Could not find promo code" }
        else
          if promo_code.user_id.nil?
            redeem_normal_code(promo_code)    
          else
            redeem_invite_code(promo_code)
          end
        end
      end
    
      private

      def redeem_normal_code(promo_code)
        promo_count = Credit.where(:promo_code_id => promo_code.id).count
        puts "promo count: #{promo_count}"
        if promo_count >= promo_code.quantity
          render :json => { :error => "Promo code has already been used" }
        else            
          if (Credit.where(:promo_code_id => promo_code.id, :user_id => current_user.id).count > 0)
            render :json => { :error => "You have already used this promo code" }
          else
            if !promo_code.random_promo.nil?
              random_number = promo_code.random_promo * 100
              r = Random.new
              random = r.rand(100)
              puts "random_number: #{random_number}, random: #{random}"
              if (random_number > random)
                credit = Credit.create(:total => promo_code.amount, :user_id => current_user.id, :promo_code_id => promo_code.id)
                render :json => { :user => current_user.as_json(:auth => true) }
              else
                credit = Credit.create(:total => 0, :user_id => current_user.id, :promo_code_id => promo_code.id)
                render :json => { :error => "Sorry, you did not win. Thanks for playing! Follow us on twitter and facebook for more chances to win!" }
              end
            else
              credit = Credit.create(:total => promo_code.amount, :user_id => current_user.id, :promo_code_id => promo_code.id)
              render :json => { :user => current_user.as_json(:auth => true) }
            end
          end
        end
      end

      def redeem_invite_code(promo_code)
        if (Credit.joins(:promo_code).where("promo_codes.user_id IS NOT NULL").where(:user_id => current_user.id).count > 0)
          render :json => { :error => "Sorry, the code you entered is only for new users" }
        else
          if (Receipt.where(:user_id => current_user.id).count > 0)
            render :json => { :error => "Sorry, the code you entered is only for new users" }
          else
            if (promo_code.user_id == current_user.id)
              render :json => { :error => "Sorry, can not use your own invitation code" }
            else
              Credit.create(:total => promo_code.amount, :user_id => current_user.id, :promo_code_id => promo_code.id)
              render :json => { :user => current_user.as_json(:auth => true) }
            end
          end
        end
      end

    end
  end
end 
