class Place < ActiveRecord::Base
  belongs_to :category
  
  validates_presence_of :name
  validates_presence_of :location  
  validates_presence_of :category_id
end


# == Schema Info
# Schema version: 20100502233032
#
# Table name: places
#
#  id          :integer(4)      not null, primary key
#  category_id :integer(4)
#  description :text
#  location    :string(255)
#  name        :string(255)
#  url         :string(255)
#  created_at  :datetime
#  updated_at  :datetime