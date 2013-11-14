require 'mandrill'

class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :token_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :favorite_places
  has_many :favorite_workouts
  has_many :favorites
  has_many :place_favorites, :through => :favorite_places, :source => :place
  has_many :checkins
  has_many :place_checkins, :through => :checkins, :source => :place
  has_many :credits
  has_one :promo_code
  # after_create :send_welcome_email
  
  after_save :set_promo_code
  
  def write_review_for_place(params, place_id)
    return Rating.new(:rating => params[:rating].to_i, :review => params[:review], :place_id => place_id.to_i, :user_id => self.id)
  end

  def write_review_for_workout(params, workout)
    return Rating.new(:rating => params[:rating].to_i, :review => params[:review], :place_id => workout.place_id, :user_id => self.id, :workout_id => workout.id, :workout_key => workout.workout_key)
  end 

  def has_payment_info?
    !!braintree_customer_id
  end

  def timeout_in
    
    if user.instance_of?(AdminUser)
      1.year
    else
      0.seconds
    end

  end

  def as_json(opts={})
    if (!opts[:auth].nil?)
      opts[:methods] ||= [:credit_amount]
    end
    
    opts[:except] ||= [ :braintree_customer_id, :updated_at, :created_at, :title, :phone, :company_id ]

    super(opts)
  end

  def send_welcome_email
    if !self.is_guest
        mandrill = Mandrill::API.new
        template_name = "tapfit-welcome-email"
        template_content = [{"content"=>"example content", "name" => "example name"}] 
        message = {}
        message["subject"] = "Welcome to TapFit!"
        message["from_email"] = "support@tapfit.co"
        message["from_name"] = "TapFit"
        message["to"] = [ {"email" => self.email, "name" => self.first_name} ]
        message["html"] = ""
        message["text"] = ""
        message["track_opens"] = true
        message["track_clicks"] = true
        async = true
        ip_pool = "Main Pool"
        puts message
        mandrill.messages.send_template(template_name, template_content, message, async, ip_pool)
    end
  end

  def credit_amount
    if self.credits.count > 0
      return self.credits.where("expiration_date IS NULL OR (expiration_date > ?)", DateTime.now).sum(:remaining)
    else
      return 0
    end
  end

  def use_credits(used_credits)
    self.credits.where("expiration_date IS NULL OR (expiration_date > ?)", DateTime.now).order(:expiration_date).each do |credit|
      if credit.remaining > used_credits
        credit.remaining = credit.remaining - used_credits
        credit.save
        break
      elsif credit.remaining > 0
        used_credits = used_credits - credit.remaining
        credit.remaining = 0
        credit.save
      end
    end
  end 

  def set_promo_code
    code = nil
    if first_name.nil?
      code = last_name
    elsif last_name.nil?
      code = first_name
    else
      code = "#{first_name[0]}#{last_name}"
    end

    if !code.nil?
      i = 1
      promo_code = PromoCode.where(:code => code).first
      if !promo_code.nil?
        puts "promo code not null"
        if !self.promo_code.nil?
          puts "user promo code not null"
          if promo_code.id == self.promo_code.id
            puts "user promo code id equal to promo code id"
            if promo_code.code == self.promo_code.code
              puts "user promo code equal to promo code"
              return
            end
          end
        end
      end
      while (!promo_code.nil?)
        new_code = "#{code}#{i}"
        i = i + 1
        promo_code = PromoCode.where(:code => new_code).first
        if promo_code.nil?
          code = new_code
        end
      end
      previous_code = PromoCode.where(:user_id => self.id).first
      if previous_code.nil?
        PromoCode.create(:code => code, :user_id => self.id)
      else
        previous_code.code = code
        previous_code.save
      end

    end

  end

end
