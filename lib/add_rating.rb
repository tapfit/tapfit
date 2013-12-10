
module AddRating

  def self.add_rating(place_id, num_of_reviews, rating)
   
    num_of_reviews = num_of_reviews.to_i
    rating = rating.to_f 
    low_rating_count = 0
    high_rating_count = num_of_reviews
    
    place = Place.find(place_id)

    while num_of_reviews > 0 do
     
      cur_rating = Rating.where(:place_id => place_id).average(:rating) 
      new_rating = nil
      if cur_rating.nil?
        new_rating = rating.round
      elsif cur_rating > rating
        new_rating = rating.floor
      else
        new_rating = rating.ceil
      end

      Rating.create(:place_id => place_id, :user_id => 8, :rating => new_rating)
      num_of_reviews = num_of_reviews - 1
    end
=begin
    if rating % 1 != 0
      low_rating_count = (num_of_reviews / 2).floor
      high_rating_count = (num_of_reviews / 2).ceil
    end

    while low_rating_count > 0 do
      Rating.create(:place_id => place_id, :user_id => 8, :rating => rating.floor)
      low_rating_count = low_rating_count - 1
    end

    while high_rating_count > 0 do
      Rating.create(:place_id => place_id, :user_id => 8, :rating => rating.ceil)
      high_rating_count = high_rating_count - 1
    end
=end
  end

end
