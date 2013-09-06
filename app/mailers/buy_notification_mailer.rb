class BuyNotificationMailer < ActionMailer::Base
  default from: "buy_confirmation@tapfit.co"
  default to: ["zack@tapfit.co"]


  @emails = [ "zack@tapfit.co", "nick@tapfit.co", "scott@tapfit.co" ]
  @numbers = [ '19377763643', '13126593275', '18474364229' ]
  def send_buy_email(receipt)
    @receipt = receipt
    @url = admin_receipts_url
    body = "#{receipt.user.first_name} just bought a pass. #{@url}"
    @numbers.each do |number|
      response = $nexmo.send_message({:to => number, :from => '17324409825', :text => body})
      if !response.ok?
        puts response.body
      end
    end
    @emails.each do |email|
      mail(to: email, subject: 'New Class Purchased!')
    end
  end 
end
