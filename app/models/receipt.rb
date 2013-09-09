class Receipt < ActiveRecord::Base

  belongs_to :user
  belongs_to :place
  belongs_to :workout
  has_one :pass_detail, :through => :workout

  def place_json
    self.place.as_json(:detail => true)
  end

  def workout_json
    self.workout.as_json(:detail => true)
  end

  def fine_print
    if self.pass_detail.nil?
      nil
    else
      self.pass_detail.fine_print
    end
  end

  def instructions
    if self.pass_detail.nil?
      nil
    else
      self.pass_detail.instructions
    end
  end

  def send_receipt_email
    
    template_name = "example template name"
    template_content = [{"content"=>"example content", "name" => "example name"}] 
    message = {}
    message["subject"] = "Thanks for purchasing a pass!"
    message["from_email"] = "support@tapfit.co"
    message["from_name"] = "TapFit Team"
    message["to"] = [ {"email" => self.user.email, "name" => self.user.first_name} ]
    message["html"] = ""
    message["text"] = ""
    message["track_opens"] = true
    message["track_clicks"] = true
    async = false
    ip_pool = "Main Pool"
    puts message
    $mandrill.messages.send_template(template_name, template_content, message, async, ip_pool)


  end
  

  def as_json(options={})
    options[:except] ||= [:place_id, :user_id, :workout_id, :workout_key, :updated_at, :has_booked ]
    options[:methods] ||= [ :instructions, :fine_print, :workout_json, :place_json ]
    options[:include] ||= [ :user ] 
    super(options)
  end 

end
