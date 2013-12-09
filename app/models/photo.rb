require 'open-uri'

class Photo < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true

  has_attached_file :image, 
    styles: {
      icon: '100x100#',
      large: 'x720'
    },
    :default_style => :icon,
    :path => ":attachment/:style/:id.jpg"

  before_validation :download_remote_image, :if => :image_url_provided?

  validates_presence_of :image_remote_url, :if => :image_url_provided?, :message => 'is invalid or inaccessible'

  def self.image_base_url
    return "https://s3-us-west-2.amazonaws.com/tapfit-production"
  end

  private

  def image_url_provided?
    puts "checking url not blank"
    !self.url.blank?
  end

  def download_remote_image
    puts "about to download remote image"
    self.image = do_download_remote_image
    self.image_remote_url = url
  end

  def do_download_remote_image
    "about to do the download of remote image"
    io = open(URI.parse(url))
    def io.original_filename; base_uri.path.split('/').last; end
    io.original_filename.blank? ? nil : io
  rescue
    puts "failed to download image"
  end
end
