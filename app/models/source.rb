class Source < ActiveRecord::Base
  has_many :webpages
  
  validates_presence_of :name
  validates_format_of :url, :with => /^http:\/\/.+/
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