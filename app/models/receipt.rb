class Receipt < ActiveRecord::Base

  belongs_to :user
  belongs_to :place
  belongs_to :workout
 

end
