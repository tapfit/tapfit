
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
    
    PromoCode.create(:code => gift_code, :amount => package.fit_coins, :quantity => 1)
    
    # Send email with package id info

  end

end

