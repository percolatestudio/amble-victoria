class User < ActiveRecord::Base
  acts_as_authentic  
  
  has_many :visits
  has_many :places, :through => :visits
  
  def before_connect(facebook_session)
    self.name = facebook_session.user.name
    reset_persistence_token
  end
end
