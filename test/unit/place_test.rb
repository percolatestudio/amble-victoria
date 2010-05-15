require 'test_helper'

class PlaceTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Info
# Schema version: 20100515171258
#
# Table name: places
#
#  id               :integer(4)      not null, primary key
#  category_id      :integer(4)
#  primary_image_id :integer(4)
#  source_id        :integer(4)
#  description      :text
#  lat              :decimal(15, 10)
#  lng              :decimal(15, 10)
#  location         :string(255)
#  name             :string(255)
#  system_quality   :integer(4)
#  user_quality     :integer(4)
#  created_at       :datetime
#  updated_at       :datetime