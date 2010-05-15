require 'test_helper'

class VisitsTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
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