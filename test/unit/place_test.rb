require 'test_helper'

class PlaceTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end


# == Schema Info
# Schema version: 20100502233032
#
# Table name: places
#
#  id          :integer(4)      not null, primary key
#  category_id :integer(4)
#  description :text
#  location    :string(255)
#  name        :string(255)
#  url         :string(255)
#  created_at  :datetime
#  updated_at  :datetime