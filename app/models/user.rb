class User < ActiveRecord::Base
  # need this to avoid a nasty infinite loop bug. due to more shitty code in the facebook plugin
  # hopefully turning this off won't bite us
  acts_as_authentic do |c|
    c.maintain_sessions = false
  end
  
  has_many :visits
  has_many :places, :through => :visits
  
  def before_connect(facebook_session)
    self.name = facebook_session.user.name
    reset_persistence_token
  end
end
