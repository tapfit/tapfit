class Category
  
  Gym = "Gym"
  Yoga = "Yoga"
  PilatesBarre = "Pilates Barre"
  Cardio = "Cardio"
  Sports = "Sports"
  Aquatics = "Aquatics"
  Dance = "Dance"
  Strength = "Strength"
  MartialArts = "Martial Arts"
  Baseball = "Baseball" # Baseball and soft
  Football = "Football"
  Soccer = "Soccer"
  Tennis = "Tennis"
  Golf = "Golf"

  def self.get_category(tags)
    array = tags.map(&:upcase) 
    if array.grep(/YOGA/).length > 0
      return Yoga
    elsif array.grep(/CARDIO/).length > 0 || array.grep(/BOOT CAMP/).length > 0
      return Cardio
    elsif array.grep(/PILATES/).length > 0 || array.grep(/BARRE/).length > 0
      return PilatesBarre
    elsif array.grep(/DANCE/).length > 0
      return Dance
    else
      return Gym
    end
  end

  def self.update_rec_centers
    
    Place.where(:source => "cincyrec").each do |place|
      name = "#{place.name.upcase} #{place.category_list.join(" ").upcase}"
      if name.include?("POOL")
        place.category = Category::Aquatics
        place.save
      elsif name.include?("BASEBALL") || name.include?("SOFTBALL")
        place.category = Catgory::Baseball
        place.save
      elsif name.include?("FOOTBALL")
        place.category = Category::Football
        place.save
      elsif name.include?("SOCCER")
        place.category = Category::Soccer
        place.save
      elsif name.include?("TENNIS")
        place.category = Category::Tennis
        place.save
      elsif name.include?("GOLF")
        place.category = Category::Golf
        place.save
      end
      # place.category = Category.get_category(place.category_list)
      # place.save
    end
  end
  def self.search_tags(tags, params)
    
  end
end
