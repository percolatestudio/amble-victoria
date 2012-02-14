class User < ActiveRecord::Base
  # need this to avoid a nasty infinite loop bug. due to more shitty code in the facebook plugin
  # hopefully turning this off won't bite us
  # acts_as_authentic do |c|
  #   c.maintain_sessions = false
  # end
  
  has_many :visits
  has_many :places, :through => :visits
  
  has_many :saved_places, :through => :visits, :conditions => ['visits.saved = ?', true], :source => :place
  
  def saved?(place)
    not saved_places.find_by_id(place.id).nil?
  end
  
  def before_connect(facebook_session)
    self.name = facebook_session.user.name
    reset_persistence_token
  end
end

# == Schema Info
# Schema version: 20100515171258
#
# Table name: users
#
#  id                   :integer(4)      not null, primary key
#  facebook_session_key :string(255)
#  facebook_uid         :integer(8)      not null
#  name                 :string(255)     not null
#  persistence_token    :string(255)
#  created_at           :datetime
#  updated_at           :datetime