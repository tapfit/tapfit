class CrawlerErrorEmail < ActionMailer::Base
  
  default from: 'zack@tapfit.com'

  EMAILS = ["zackmartinsek@gmail.com"]

  def self.error_email(message)
    EMAILS.each do |email|
      send_email(email, message)
    end
  end

  def send_email(email, message)
    puts "Sending Email: message"
    mail(to: email,
         body: message,
         content_type: "text/html",
         subject: "Crawler Report #{DateTime.now}").deliver
  end
end
