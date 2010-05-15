require 'test_helper'

class SourceTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Info
# Schema version: 20100515171258
#
# Table name: sources
#
#  id            :integer(4)      not null, primary key
#  icon_filename :string(255)
#  name          :string(255)
#  url           :string(255)
#  created_at    :datetime
#  updated_at    :datetime