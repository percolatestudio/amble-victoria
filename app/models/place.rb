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
  
  before_create :set_image
  
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
  
  #return url's of creative common licensed pictures from flickr for this place
  def potential_images(opts = {:max => 5})
    flickr = Flickr.new(File.join(RAILS_ROOT, 'config', 'flickr.yml'))
    photos = flickr.photos.search(:text => self.name, 
                                  :per_page => opts[:max], 
                                  :content_type  => 1, 
                                  :safe_search => 1, 
                                  :privacy_filter => 1, 
                                  :sort => 'relevance', 
                                  :license => '1,2,3,4,5,6,7,8')
                                  
    photos.collect { |p| p.image_url }
  end
  
  def set_image_from_flickr
    self.image_url = potential_images({:max => 1}).first
    set_image_from_image_url
  end
  
protected
  def set_image
    begin
      if (self.image_url.empty?) and (!self.image.file?)        
        puts "setting image from flickr"
        self.set_image_from_flickr
      elsif (!self.image_url.empty?) and (!self.image.file?)
        puts "setting image from url: #{self.image_url}"
        self.set_image_from_image_url
      end
    rescue
      puts "error setting place image"
    end
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