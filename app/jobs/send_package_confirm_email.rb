require 'mandrill'
require 'resque'
require './lib/resque_job'

class SendPackageConfirmEmail < ResqueJob

  @queue = :email

  def self.perform(email, package_id, gift_email)

    package = Package.find(package_id)
    gift_code = SecureRandom.hex(7)

    while (PromoCode.where(:code => gift_code).count > 0) do
      gift_code = SecureRandom.hex(7)
    end
    
    code = PromoCode.create(:code => gift_code, :amount => package.fit_coins, :quantity => 1)
      
    giftor = User.where(:email => email).first
    giftee = User.where(:email => gift_email).first

    if !gift_email.nil?
      send_gift_receipt_email(gift_code, email, gift_email)

      if giftee.nil?
        send_gift_email(gift_code, email, gift_email)
      else
        Credit.create(:total => code.amount, :user_id => giftee.id, :promo_code_id => code.id)
        send_user_gift_email(email, gift_email)
      end
    else
      if giftor.nil?
        send_receipt_email(gift_code, email)
      else
        Credit.create(:total => code.amount, :user_id => giftor.id, :promo_code_id => code.id) 
        send_user_receipt_email(email)
      end
    end

  end

  def send_receipt_email(gift_code, email)
        
    mandrill = Mandrill::API.new 
    template_name = "tapfit-purchase-confirmation"
    template_content = [{"content"=>"example content", "name" => "example name"}] 
    message = {}
    message["subject"] = "Purchase Confirmed: Thanks for your purchase!"
    message["from_email"] = "support@tapfit.co"
    message["from_name"] = "TapFit"
    message["to"] = [ {"email" => email} ]
    message["html"] = ""
    message["text"] = ""
    message["merge_vars"] = [{"vars"=>[{"content"=>self.workout.name, "name"=>"WORKOUT"},
                                       {"content"=>self.place.name, "name"=>"PLACE"},
                                       {"content"=>self.workout.start_time.strftime("%A"), "name"=>"WORKOUT_DAY"},
                                       {"content"=>self.workout.start_time.strftime("%l:%M%P"), "name"=>"WORKOUT_TIME"},
                                       {"content"=>self.created_at.strftime("%A, %B %-d, %Y"), "name"=>"ORDER_DATE"},
                                       {"content"=>self.price, "name"=>"SUBTOTAL"},
                                       {"content"=>self.price, "name"=>"TOTAL"}], "rcpt"=>self.user.email}]
    message["merge"] = true
    message["track_opens"] = true
    message["track_clicks"] = true
    async = true
    ip_pool = "Main Pool"
    mandrill.messages.send_template(template_name, template_content, message, async, ip_pool)

  end

  def send_gift_receipt_email(gift_code, email, gift_email)
        
    mandrill = Mandrill::API.new 
    template_name = "tapfit-purchase-confirmation"
    template_content = [{"content"=>"example content", "name" => "example name"}] 
    message = {}
    message["subject"] = "Purchase Confirmed: Thanks for your purchase!"
    message["from_email"] = "support@tapfit.co"
    message["from_name"] = "TapFit"
    message["to"] = [ {"email" => email} ]
    message["html"] = ""
    message["text"] = ""
    message["merge_vars"] = [{"vars"=>[{"content"=>self.workout.name, "name"=>"WORKOUT"},
                                       {"content"=>self.place.name, "name"=>"PLACE"},
                                       {"content"=>self.workout.start_time.strftime("%A"), "name"=>"WORKOUT_DAY"},
                                       {"content"=>self.workout.start_time.strftime("%l:%M%P"), "name"=>"WORKOUT_TIME"},
                                       {"content"=>self.created_at.strftime("%A, %B %-d, %Y"), "name"=>"ORDER_DATE"},
                                       {"content"=>self.price, "name"=>"SUBTOTAL"},
                                       {"content"=>self.price, "name"=>"TOTAL"}], "rcpt"=>self.user.email}]
    message["merge"] = true
    message["track_opens"] = true
    message["track_clicks"] = true
    async = true
    ip_pool = "Main Pool"
    mandrill.messages.send_template(template_name, template_content, message, async, ip_pool)

  end

  def send_gift_email(gift_code, email, gift_email)
    mandrill = Mandrill::API.new 
    template_name = "tapfit-purchase-confirmation"
    template_content = [{"content"=>"example content", "name" => "example name"}] 
    message = {}
    message["subject"] = "Purchase Confirmed: Thanks for your purchase!"
    message["from_email"] = "support@tapfit.co"
    message["from_name"] = "TapFit"
    message["to"] = [ {"email" => gift_email} ]
    message["html"] = ""
    message["text"] = ""
    message["merge_vars"] = [{"vars"=>[{"content"=>self.workout.name, "name"=>"WORKOUT"},
                                       {"content"=>self.place.name, "name"=>"PLACE"},
                                       {"content"=>self.workout.start_time.strftime("%A"), "name"=>"WORKOUT_DAY"},
                                       {"content"=>self.workout.start_time.strftime("%l:%M%P"), "name"=>"WORKOUT_TIME"},
                                       {"content"=>self.created_at.strftime("%A, %B %-d, %Y"), "name"=>"ORDER_DATE"},
                                       {"content"=>self.price, "name"=>"SUBTOTAL"},
                                       {"content"=>self.price, "name"=>"TOTAL"}], "rcpt"=>self.user.email}]
    message["merge"] = true
    message["track_opens"] = true
    message["track_clicks"] = true
    async = true
    ip_pool = "Main Pool"
    mandrill.messages.send_template(template_name, template_content, message, async, ip_pool)

  end

end

