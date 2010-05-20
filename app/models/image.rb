require 'net/http'

class Image < ActiveRecord::Base
  belongs_to :place
  
  IMAGE_SIZES = { 
    :small => {:x => 80, :y => 77},
    :medium => {:x => 290, :y => 178},
  }            
  
  has_attached_file :image, 
    :styles => {:medium => ["#{IMAGE_SIZES[:medium][:x]}x#{IMAGE_SIZES[:medium][:y]}#", :jpg],
                :small => ["#{IMAGE_SIZES[:small][:x]}x#{IMAGE_SIZES[:small][:y]}#", :jpg]},
    :convert_options => {:all => "-strip -quality 80"},
    :default_style => :small,
    :default_url => "/images/default_image_:style.png",
    :path => ":rails_root/public/system/:attachment/:id_partition/:id/:style.:extension",
    :url => "/system/:attachment/:id_partition/:id/:style.:extension"
  
  validates_presence_of :image_file_name
    
  #download and set the image from the specified url if it's not already set
  before_validation { |record|
    unless record.image_file_name? 
      record.set_image_from_url 
    end
  }
  
  #set/download the image based on the URL if provided
  def set_image_from_url
    begin
      logger.info "downloading image..."
      contents = open(self.url)
      logger.info "setting self.image to: #{contents}"
      logger.info "file is #{contents.path}"
      self.image = contents
      #self.image = open(self.url)
      logger.info "set self.image to be: #{self.image}, from url: #{self.url}"
    rescue
      return false
    end
    
    true
  end   
  
end

# == Schema Info
# Schema version: 20100515171258
#
# Table name: images
#
#  id              :integer(4)      not null, primary key
#  place_id        :integer(4)
#  image_file_name :string(255)
#  url             :string(2048)
#  created_at      :datetime
#  updated_at      :datetime