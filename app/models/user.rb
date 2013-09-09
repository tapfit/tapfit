class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :token_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :favorite_places
  has_many :favorite_workouts
  has_many :favorites
  has_many :place_favorites, :through => :favorite_places, :source => :place
  has_many :checkins
  has_many :place_checkins, :through => :checkins, :source => :place
  # after_create :send_welcome_email
  
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

    opts[:except] ||= [ :braintree_customer_id, :updated_at, :created_at ]

    super(opts)
    
  end

  def send_welcome_email
    if !self.is_guest
      message = {}
      message["subject"] = "Welcome to TapFit!"
      message["from_email"] = "support@tapfit.co"
      message["from_name"] = "TapFit Team"
      message["to"] = [ {"email" => self.email, "name" => self.first_name} ]
      message["html"] = ""
      message["text"] = ""
      message["track_opens"] = true
      message["track_clicks"] = true
      async = false
      ip_pool = "Main Pool"
      puts message
      $mandrill.messages.send(message, async, ip_pool)
    end
  end

end
