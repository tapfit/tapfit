class PlaceContract < ActiveRecord::Base
  belongs_to :place

  validate :contract_valid

  def contract_valid
    if self.price.nil? && self.discount.nil?
      errors.add(:price, "price cannot be nil") unless !self.price.nil?
      errors.add(:discount, "discount cannot be nil") unless !self.discount.nil?
    end
  end
end
