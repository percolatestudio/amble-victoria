class Webpage < ActiveRecord::Base
  belongs_to :source
  belongs_to :place
  
end

# == Schema Info
# Schema version: 20100510021227
#
# Table name: webpages
#
#  id         :integer(4)      not null, primary key
#  place_id   :integer(4)
#  website_id :integer(4)
#  url        :string(255)
#  created_at :datetime
#  updated_at :datetime