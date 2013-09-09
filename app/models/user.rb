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
    begin
    mandrill = Mandrill::API.new 'w-ahykM1JL_ruQwu40d-5w'
    template_name = "tapfit-purchase-confirmation"
    template_content = [{"content"=>"example content", "name"=>"example name"}]
    message = {"global_merge_vars"=>[{"content"=>"merge1 content", "name"=>"merge1"}],
    "to"=>[{"name"=>self.first_name + self.last_name, "email"=>self.email}],
    "signing_domain"=>nil,
    "preserve_recipients"=>nil,
    "google_analytics_domains"=>["example.com"],
    "return_path_domain"=>nil,
        "auto_text"=>nil,
        "track_opens"=>nil,
        "images"=>
        [{"content"=>"ZXhhbXBsZSBmaWxl", "name"=>"IMAGECID", "type"=>"image/png"}],
        "tracking_domain"=>nil,
        "view_content_link"=>nil,
        "track_clicks"=>nil,
        "important"=>false,
        "subject"=>"Purchase Confirmed: Thanks for your purchase!",
        "html"=>"<p>Example HTML content</p>",
        "auto_html"=>nil,
        "inline_css"=>nil,
        "from_email"=>"message.from_email@example.com",
        "attachments"=>
        [{"content"=>"ZXhhbXBsZSBmaWxl",
        "name"=>"myfile.txt",
        "type"=>"text/plain"}],
        "tags"=>["password-resets"],
        "merge_vars"=>
        [{"vars"=>[{"content"=>"merge2 content", "name"=>"merge2"}],
        "rcpt"=>self.email}],
        "merge"=>true,
        "bcc_address"=>"support@tapfit.co",
        "text"=>"Example text content",
        "metadata"=>{"website"=>"www.tapfit.co"},
        "subaccount"=>"customer-123",
        "url_strip_qs"=>nil,
        "headers"=>{"Reply-To"=>"support@tapfit.co"},
        "recipient_metadata"=>
        [{"values"=>{"user_id"=>self.id}, "rcpt"=>self.email}],
        "from_name"=>"TapFit"}
        async = false
        ip_pool = "Main Pool"
        result = mandrill.messages.send_template template_name, template_content, message, async, ip_pool, send_at
        rescue Mandrill::Error => e
        # Mandrill errors are thrown as exceptions
        puts "A mandrill error occurred: #{e.class} - #{e.message}"
        # A mandrill error occurred: Mandrill::UnknownSubaccountError - No subaccount exists with the id 'customer-123'    
        raise
        end
      end
  end
end
