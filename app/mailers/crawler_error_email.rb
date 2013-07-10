class CrawlerErrorEmail < ActionMailer::Base
  
  EMAILS = ["zackmartinsek@gmail.com"]

  def error_email(message)
    EMAILS.each do |email|
      send_email(email, message)
    end
  end

  def send_email(email, message)
    puts "Sending Email: message"
    mail(to: email,
         body: message,
         content_type: "text/html",
         subject: "Crawler Report #{DateTime.now}")
  end
end
