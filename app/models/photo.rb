class Photo < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true

  has_attached_file :image, 
    styles: {
      icon: '100x100#',
      large: 'x720'
    },
    :default_style => :icon

end
