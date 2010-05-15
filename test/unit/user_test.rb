require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
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