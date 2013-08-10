class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :token_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :favorite_places
  has_many :favorite_workouts
  has_many :favorites
  has_many :place_favorites, :through => :favorite_places, :source => :place
  has_many :checkins
  has_many :place_checkins, :through => :checkins, :source => :place
  
  def write_review_for_place(params, place_id)
    return Rating.new(:rating => params[:rating].to_i, :review => params[:review], :place_id => place_id.to_i, :user_id => self.id)
  end 

  def has_payment_info?
    !!braintree_customer_id
  end

end
