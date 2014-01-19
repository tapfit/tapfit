class Credit < ActiveRecord::Base
  belongs_to :user
  belongs_to :promo_code
  belongs_to :package
  belongs_to :source, polymorphic: true

  before_create :default_values

  def default_values
    if !self.total.nil?
      self.remaining = self.total
    elsif !self.promo_code.nil?
      self.total = self.promo_code.amount
      self.remaining = self.total
    elsif !self.package.nil?
      self.total = self.package.fit_coins
      self.remaining = self.total
    end
  end

end
