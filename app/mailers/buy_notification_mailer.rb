class BuyNotificationMailer < ActionMailer::Base
  default from: "buy_confirmation@tapfit.co"
  default to: ["zack@tapfit.co"]


  @emails = [ "zack@tapfit.co"]

  def send_buy_email(receipt)
    puts "place: #{receipt.place}"
    @receipt = receipt
    mail(to: 'zack@tapfit.co', subject: 'New Class Purchased!')
  end 
end
