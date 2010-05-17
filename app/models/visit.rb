class Visit < ActiveRecord::Base
  belongs_to :user
  belongs_to :place
  
  validates_presence_of [:user, :place]
  validates_uniqueness_of :user_id, :scope => :place_id
  
  named_scope :saved, :conditions => {:saved => true}
end


# == Schema Info
# Schema version: 20100515171258
#
# Table name: visits
#
#  id         :integer(4)      not null, primary key
#  place_id   :integer(4)      not null
#  user_id    :integer(4)      not null
#  pending    :boolean(1)      default(TRUE)
#  shared     :boolean(1)
#  visited    :boolean(1)
#  created_at :datetime
#  updated_at :datetime