require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Info
# Schema version: 20100510021227
#
# Table name: images
#
#  id              :integer(4)      not null, primary key
#  place_id        :integer(4)
#  image_file_name :string(255)
#  url             :string(255)
#  created_at      :datetime
#  updated_at      :datetime