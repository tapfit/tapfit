module Api
  module V1
    class UsersController < ApplicationController     
      # before_filter :authenticate_user!
      before_filter :authenticate_user!, :only => [ :show ]
      skip_before_filter :verify_authenticity_token, :only => [:login, :register, :forgotpassword]

      respond_to :json 

      # Profile info
      # GET users/<id> (GET me/ routes to users/<current_user.id>)
      def show
        puts "auth token: #{current_user.authentication_token}"
        user = user_from_user_id
        render :json => { :user => user.as_json }
      end

      # Registers a new user
      # POST users/register    
      def register
        # puts current_user
        if !params[:auth_token].nil? && user_signed_in?
          puts params[:auth_token]
          # puts current_user
          user = User.where(:email => user_params[:email]).first
          if !user.nil?
            render :json => { :error => "Email, #{user_params[:email]} already exists" } and return
          end
          current_user.update_attributes(user_params)
          current_user.update_attributes(:is_guest => false)
          user = current_user
        else
          user = User.new(user_params)
        end

        if user.valid?
          user.save
          sign_in(:user, user)
          user.ensure_authentication_token!
         
          
          result = Braintree::Customer.create(
            :first_name => user.first_name,
            :last_name => user.last_name,
            :email => user.email,
            :id => user.id
          )
          
          if result.success?
            user.braintree_customer_id = result.customer.id
            user.save
          end

          render :json => { :email => user.email, :id => user.id, :auth_token => user.authentication_token, :first_name => user.first_name, :last_name => user.last_name }
        else
          puts "user failed rendering json"
          puts "full messages: #{user.errors.full_messages.join(", ")}"
          render :json => { :error => "#{user.errors.full_messages.join(", ")}" }, :status => 422 and return
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
          render :json => { :email => user.email, :id => user.id, :auth_token => user.authentication_token, :first_name => user.first_name, :last_name => user.last_name }
        else
          render :json => { :errors => "Not valid email or password" }, :status => 403
        end   
      end

      # Register guest
      # POST users/guest
      def guest
        temp_email = "guest_#{Time.now.to_i}#{rand(99)}@example.com"
        user = User.new(:email => temp_email, :password => "12345678")

        user.is_guest = true

        if user.valid?
          user.save
          sign_in(:user, user)
          user.ensure_authentication_token!

          render :json => { :guest => true, :email => user.email, :id => user.id, :auth_token => user.authentication_token }
        else
          render :json => { :errors => user.errors }, :status => 420
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
        params.require(:user).permit(:email, :password, :first_name, :last_name)
      end

      def user_from_user_id
        puts "params: #{params[:id]}"
        if params[:id].nil? && current_user
          user = current_user
        else
          puts "finding current user"
          user = User.where(:id => params[:id]).first
        end

        raise ActiveRecord::RecordNotFound unless user
        return user
      end

    end
  end
end
