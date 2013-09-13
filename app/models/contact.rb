class Contact < User

  belongs_to :company

  validates :title, :phone, :presence => true 

end
