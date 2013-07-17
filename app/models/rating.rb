class Rating < ActiveRecord::Base
  belongs_to :user
  belongs_to :place
  belongs_to :workout

  validates :rating, :inclusion => 1..5, :presence => true
  validates :user_id, :presence => true
  validates :place_id, :presence => true

  scope :reviews, -> { where("review IS NOT NULL") }

  self.per_page = 25
end
