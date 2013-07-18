class Photo < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true

  has_attached_file :image, 
    styles: {
      icon: '100x100#',
      large: 'x720'
    },
    :default_style => :icon,
    :path => ":attachment/:style/:id.:extension"

  def self.image_base_url
    return "https://s3-us-west-2.amazonaws.com/tapfit-staging"
  end
end
