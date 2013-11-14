require 'resque'
require './lib/resque_job'

class AddCreditsToInvitor < ResqueJob

  @queue = :credits

  def self.perform(user_id, pass_count)
    puts "pass_count: #{pass_count}, user_id: #{user_id}"
    if (pass_count == 0)
      Credit.where(:user_id => user_id).each do |credit|
        puts "credit attributes: #{credit.attributes}"
        if (!credit.promo_code.user_id.nil?)
          Credit.create(:promo_code_id => credit.promo_code.id, :total => credit.promo_code.amount, :user_id => credit.promo_code.user_id)
        end
      end
    end
  end

end
