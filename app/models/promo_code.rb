class PromoCode < ActiveRecord::Base
  belongs_to :company
  belongs_to :user
  has_many :credits, as: :source

  validates :code, :uniqueness => true

  before_create :default_values

  def default_values
    if self.has_used.nil?
      self.has_used = false
      return true
    end
  end

  def codes_used
    return Credit.where(:promo_code_id => self.id).count
  end
end
