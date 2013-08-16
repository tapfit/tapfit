class Rating < ActiveRecord::Base
  belongs_to :user
  belongs_to :place
  belongs_to :workout

  validates :rating, :inclusion => 1..5, :presence => true
  validates :user_id, :presence => true
  validates :place_id, :presence => true

  scope :reviews, -> { where("review IS NOT NULL") }

  self.per_page = 25

  def name
    return "#{self.user.first_name} #{self.user.last_name}"
  end

  def as_json(opts={})
    
    if !opts[:list].nil?
      opts[:except] ||= [ :created_at, :updated_at, :workout_id, :workout_key, :place_id, :user_id ]
      opts[:methods] ||= [ :name ]
    elsif !opts[:detail].nil?
      opts[:except] ||= [ :created_at, :updated_at, :workout_id, :workout_key, :place_id ]
      opts[:methods] ||= [ :name ]
    end
    super(opts)

  end
end
