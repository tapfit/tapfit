class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :place

  validates :place_id, :presence => true
  validates :user_id, :presence => true
end
