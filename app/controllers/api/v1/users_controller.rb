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
        if (current_user == user)
          render :json => { :user => user.as_json(:auth => true) }
        else
          render :json => { :user => user.as_json }
        end
      end

      # Registers a new user
      # POST users/register    
      def register
        # puts current_user
        if !params[:auth_token].nil? && user_signed_in?

          if !params[:access_token].nil?
            facebook_user = register_facebook_user(params[:access_token])
            current_user.update_attributes(:provider => "facebook", :uid => facebook_user.uid)
            if current_user.is_guest
              current_user.update_attributes(:first_name => facebook_user.first_name,
                                             :last_name => facebook_user.last_name,
                                             :email => facebook_user.email)
            end
          else

            user = User.where(:email => user_params[:email]).first
            if !user.nil?
              render :json => { :error => "Email, #{user_params[:email]} already exists" } and return
            end
            current_user.update_attributes(user_params)
          end
          
          current_user.update_attributes(:is_guest => false)

          user = current_user
        
        else
          if !params[:access_token].nil?
            user = register_facebook_user(params[:access_token])
          else
            user = User.new(user_params)
          end
        end

        if user.nil?
          return
        end

        if user.valid?
          user.save
          sign_in(:user, user)
          user.ensure_authentication_token!

          Resque.enqueue(SendWelcomeEmail, user.id)
          # user.send_welcome_email
          
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

          location = user.location
          uid = user.uid
          gender = user.gender

          location = "" if location.nil?
          uid = "" if uid.nil?
          gender = "" if gender.nil?

          render :json => { :email => user.email, :id => user.id, :auth_token => user.authentication_token, :first_name => user.first_name, :last_name => user.last_name, :credit_amount => user.credit_amount, :uid => uid, :invitation_code => user.invitation_code, :gender => gender, :location => location }
        else
          puts "user failed rendering json"
          puts "full messages: #{user.errors.full_messages.join(", ")}"
          render :json => { :error => "#{user.errors.full_messages.join(", ")}" }, :status => 422 and return
        end
      end

      # Signs in an existing user
      # POST customers/login
      def login
        if !params[:access_token].nil?
          facebook_user = register_facebook_user(params[:access_token])
          user = User.where(:email => facebook_user.email).first
          if user.nil?
            register
            return
          end
        else
          email = params[:email]
          password = params[:password]
          user = User.where(:email => email).first
        end

        if !user.nil? && (user.valid_password?(password) || !params[:access_token].nil?)
          sign_in(:user, user)

          location = user.location
          uid = user.uid
          gender = user.gender

          location = "" if location.nil?
          uid = "" if uid.nil?
          gender = "" if gender.nil?

          user.reset_authentication_token!
          render :json => { :email => user.email, :id => user.id, :auth_token => user.authentication_token, :first_name => user.first_name, :last_name => user.last_name, :credit_amount => user.credit_amount, :uid => uid, :invitation_code => user.invitation_code, :gender => gender, :location => location }
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
        params.require(:user).permit(:email, :password, :first_name, :last_name, :phone)
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

      def register_facebook_user(access_token)
        puts "register_facebook_user"
        http = Curl.get("https://graph.facebook.com/app", { :access_token => access_token } )

        id = JSON.parse(http.body_str)['id']
        
        puts "facebook id: #{id}"

        if (id != "567244006675246")
          render :json => { :message => "Access token came from a different app than TapFit" } and return
        end

        http = Curl.get("https://graph.facebook.com/me?scope=email,first_name,last_name,id,gender,birthday,location", { :access_token => access_token })
        result = JSON.parse(http.body_str)
        uid = result['id']

        puts "uid: #{uid}" 

        user = User.where(:uid => uid).first

        unless user

          email = result['email']
          first_name = result['first_name']
          last_name = result['last_name']
          gender = result['gender']
          begin
            birthday = Date.strptime(result['birthday'], "%m/%d/%Y")
          rescue
            birthday = nil
          end
          location = ""
          if !result['location'].nil?
            location = result['location']['name']
          end

          user = User.new(:email => email,
                             :first_name => first_name,
                             :last_name => last_name,
                             :password => Devise.friendly_token[0,20],
                             :gender => gender,
                             :birthday => birthday,
                             :location => location,
                             :uid => uid,
                             :provider => "facebook"
                         )

        end
        return user
      end


    end
  end
end
