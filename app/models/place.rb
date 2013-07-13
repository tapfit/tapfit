class Place < ActiveRecord::Base
  acts_as_taggable_on :categories
end
