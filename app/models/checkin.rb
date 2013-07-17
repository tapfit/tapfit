class Checkin < ActiveRecord::Base
  belongs_to :place
  belongs_to :user

  def place_json
    self.place.as_json(:list => true)
  end

  def as_json(opts={})
    if !opts[:list].nil?
      opts[:except] ||= [ :user_id, :place_id, :lat, :lon, :updated_at ]
      opts[:methods] ||= [ :place_json ]
    end
    super(opts) 
  end
end
