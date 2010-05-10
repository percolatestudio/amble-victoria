require 'test_helper'

class UrlTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end


# == Schema Info
# Schema version: 20100510021227
#
# Table name: urls
#
#  id         :integer(4)      not null, primary key
#  place_id   :integer(4)
#  source_id  :integer(4)
#  resource   :integer(4)
#  url        :string(255)
#  created_at :datetime
#  updated_at :datetime