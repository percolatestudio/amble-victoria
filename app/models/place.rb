require 'open-uri'

class Place < ActiveRecord::Base
  IMAGE_SIZES = { 
    :small => {:x => 200, :y => 200}, 
    :medium => {:x => 320, :y => 350},
  }            
  
  belongs_to :category
  
  validates_presence_of :name
  validates_presence_of :location  
  validates_presence_of :category_id
  
  before_create { |place|
    if (!place.image_url.empty?) and (!place.image.file?)
      begin
        puts "setting image from url: #{place.image_url}"
        place.set_image_from_image_url
      rescue
      end
    end
  }
  
  has_attached_file :image, 
    :styles => {:medium => ["#{IMAGE_SIZES[:medium][:x]}x#{IMAGE_SIZES[:medium][:y]}#", :jpg],
                :small => ["#{IMAGE_SIZES[:small][:x]}x#{IMAGE_SIZES[:small][:y]}#", :jpg]},
    :convert_options => {:all => "-strip"},                                
    :default_style => :small,
    :default_url => "/images/default_image_:style.png",
    :path => ":rails_root/public/system/:attachment/:id_partition/:id/:style.:extension",
    :url => "/system/:attachment/:id_partition/:id/:style.:extension"
  
  attr_accessor :lat, :lng
  
  def set_image_from_image_url
    self.image = open(self.image_url)
  end  
  
end

# == Schema Info
# Schema version: 20100507144155
#
# Table name: places
#
#  id              :integer(4)      not null, primary key
#  category_id     :integer(4)
#  description     :text
#  image_file_name :string(255)
#  image_url       :string(255)
#  location        :string(255)
#  name            :string(255)
#  url             :string(255)
#  created_at      :datetime
#  updated_at      :datetime