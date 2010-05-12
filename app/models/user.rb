class User < ActiveRecord::Base
  acts_as_authentic  
  
  def before_connect(facebook_session)
    self.name = facebook_session.user.name
  end
end
