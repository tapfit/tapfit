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
      SendPackageConfirmEmail.send_gift_receipt_email(email, gift_email, package)
      if giftee.nil?
        SendPackageConfirmEmail.send_gift_email(gift_code, email, gift_email, package)
      else
        Credit.create(:total => code.amount, :user_id => giftee.id, :promo_code_id => code.id)
        SendPackageConfirmEmail.send_user_gift_email(gift_code, email, gift_email, package)
      end
    else
      if giftor.nil?
        SendPackageConfirmEmail.send_receipt_email(gift_code, email, package)
      else
        Credit.create(:total => code.amount, :user_id => giftor.id, :promo_code_id => code.id) 
        SendPackageConfirmEmail.send_user_receipt_email(gift_code, email, package)
      end
    end

  end

  # ---------------------------------- #
  # ------ Receipt for non-user ------ #
  # ---------------------------------- #
  def self.send_receipt_email(gift_code, email, package)
        
    mandrill = Mandrill::API.new 
    template_name = "package-receipt-nonuser"
    template_content = [{"content"=>"example content", "name" => "example name"}] 
    message = {}
    message["subject"] = "Purchase Confirmed: Thanks for your purchase!"
    message["from_email"] = "support@tapfit.co"
    message["from_name"] = "TapFit"
    message["to"] = [ {"email" => email} ]
    message["html"] = ""
    message["text"] = ""
    message["merge_vars"] = [{"vars"=>[{"content"=>package.fit_coins, "name"=>"GIFT"},
                                       {"content"=>gift_code, "name"=>"PROMO"}], "rcpt"=>email}]
    message["merge"] = true
    message["track_opens"] = true
    message["track_clicks"] = true
    async = true
    ip_pool = "Main Pool"
    mandrill.messages.send_template(template_name, template_content, message, async, ip_pool)

  end
  
  # ---------------------------------- #
  # -------- Receipt for user -------- #
  # ---------------------------------- #
  def self.send_user_receipt_email(gift_code, email, package)
        
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
    message["merge_vars"] = [{"vars"=>[{"content"=>package.fit_coins, "name"=>"GIFT"},
                                       {"content"=>gift_code, "name"=>"PROMO"}], "rcpt"=>email}]
    message["merge"] = true
    message["track_opens"] = true
    message["track_clicks"] = true
    async = true
    ip_pool = "Main Pool"
    mandrill.messages.send_template(template_name, template_content, message, async, ip_pool)

  end
  
  # ---------------------------------- #
  # --------- Gift for user ---------- #
  # ---------------------------------- #
  def self.send_user_gift_email(gift_code, email, gift_email, package)
        
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
    message["merge_vars"] = [{"vars"=>[{"content"=>package.fit_coins, "name"=>"GIFT"},
                                       {"content"=>email, "name"=>"SENDER"},
                                       {"content"=>gift_code, "name"=>"PROMO"}], "rcpt"=>gift_email}]
    message["merge"] = true
    message["track_opens"] = true
    message["track_clicks"] = true
    async = true
    ip_pool = "Main Pool"
    mandrill.messages.send_template(template_name, template_content, message, async, ip_pool)

  end

  # ---------------------------------- #
  # ---- Gift receipt for giftor ----- #
  # ---------------------------------- #
  def self.send_gift_receipt_email(email, gift_email, package)
        
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
    message["merge_vars"] = [{"vars"=>[{"content"=>package.fit_coins, "name"=>"GIFT"},
                                       {"content"=>gift_email, "name"=>"RECIPIENT"},
                                       {"content"=>package.created_at.strftime("%A, %B %-d, %Y"), "name"=>"ORDER_DATE"},
                                       {"content"=>package.amount, "name"=>"SUBTOTAL"},
                                       {"content"=>package.amount, "name"=>"TOTAL"}], "rcpt"=>email}]
    message["merge"] = true
    message["track_opens"] = true
    message["track_clicks"] = true
    async = true
    ip_pool = "Main Pool"
    mandrill.messages.send_template(template_name, template_content, message, async, ip_pool)

  end

  # ---------------------------------- #
  # -------- Gift for non-user ------- #
  # ---------------------------------- #
  def self.send_gift_email(gift_code, email, gift_email, package)
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
    message["merge_vars"] = [{"vars"=>[{"content"=>package.fit_coins, "name"=>"GIFT"},
                                       {"content"=>email, "name"=>"SENDER"},
                                       {"content"=>gift_code, "name"=>"PROMO"}], "rcpt"=>gift_email}]
    message["merge"] = true
    message["track_opens"] = true
    message["track_clicks"] = true
    async = true
    ip_pool = "Main Pool"
    mandrill.messages.send_template(template_name, template_content, message, async, ip_pool)

  end

end

