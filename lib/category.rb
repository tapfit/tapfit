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

  def self.update_go_recess
    
    Place.where(:source => "goRecess").each do |place|
      place.category = Category.get_category(place.category_list)
      place.save
    end
  end
  def self.search_tags(tags, params)
    
  end
end
