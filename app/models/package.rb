class Package < ActiveRecord::Base

  has_many :credits, as: :source

  def discounted_amount
    if self.discount.nil?
      return self.amount
    else
      return (self.amount * (1 - self.discount)).round    
    end
  end

  def buy_package(user)
    Credit.create(:package_id => self.id, :total => self.fit_coins, :user_id => user.id)
  end
end
