class Category < ActiveRecord::Base
  has_many :places
  
  validates_presence_of :name
    
end

# == Schema Info
# Schema version: 20100510021227
#
# Table name: categories
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime