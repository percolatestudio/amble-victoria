class Webpage < ActiveRecord::Base
  belongs_to :source
  belongs_to :place
  
end

# == Schema Info
# Schema version: 20100515171258
#
# Table name: webpages
#
#  id         :integer(4)      not null, primary key
#  place_id   :integer(4)
#  source_id  :integer(4)
#  url        :string(255)
#  created_at :datetime
#  updated_at :datetime