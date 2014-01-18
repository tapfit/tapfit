class Credit < ActiveRecord::Base
  belongs_to :user
  belongs_to :promo_code
  belongs_to :package
  belongs_to :source, polymorphic: true

  before_create :default_values

  def default_values
    if !self.total.nil?
      self.remaining = self.total
    end
  end

end
