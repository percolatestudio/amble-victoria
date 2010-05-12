class UserSession < Authlogic::Session::Base
  facebook_valid_user true
end