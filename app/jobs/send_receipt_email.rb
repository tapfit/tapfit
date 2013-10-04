require 'resque'
require './lib/resque_job'

class SendReceiptEmail < ResqueJob

  @queue = :email

  def self.perform(receipt_id)
    receipt = Receipt.find(receipt_id)

    receipt.send_receipt_email 
  end

end
