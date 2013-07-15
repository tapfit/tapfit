module Api
  module V1
    class UsersController < ApplicationController
      
      # Registers a new user
      # POST users/register    
      def register
        user = User.new(user_params)
        if user.valid?
          user.save
          sign_in(:user, user)
          user.ensure_authentication_token!
          render :json => { :email => user.email, :id => user.id, :auth_token => user.authentication_token }
        else
          render :json => { :errors => user.errors }
        end
      end

      # Signs in an existing user
      # POST customers/login
      def login
        email = params[:email]
        password = params[:password]
        user = User.where(:email => email).first
        if !user.nil? && user.valid_password?(password)
          sign_in(:user, user)
          user.reset_authentication_token!
          render :json => { :email => user.email, :id => user.id, :auth_token => user.authentication_token }
        else
          render :json => { :errors => "Not valid email or password" }
        end   
      end

      # Logouts a user out
      # POST users/logout
      def logout
        sign_out(current_user)
        current_user.authentication_token = nil
        current_user.save
        render :json => { :messgae => "Successfully logged out" }        
      end

      # Sends a forgot password email
      # POST users/forgotpassword
      def forgotpassword
        email = params[:email]
        user = User.where(:email => email).first
        if !user.nil?
          user.send_reset_password_instructions
          render :json => { :message => "Succesfully sent email" }
        else
          render :json => { :errors => "Not valid email" }
        end
      end
      
      private

      def user_params
        params.permit(:email, :password, :first_name, :last_name)
      end
    end
  end
end
