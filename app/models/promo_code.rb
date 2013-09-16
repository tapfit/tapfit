class PromoCode < ActiveRecord::Base
  belongs_to :company

  before_create :default_values

  def default_values
    if self.has_used.nil?
      self.has_used = false
      return true
    end
  end
end
