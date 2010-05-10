class Place < ActiveRecord::Base
  
  belongs_to :category
  has_many :webpages
  has_many :images
  has_one :primary_image, :order => 'created_at asc', :class_name => 'Image'
  
  validates_presence_of :name
  validates_presence_of :location  
  validates_presence_of :category_id
  
  validates_presence_of :images
  validates_associated :images
  
  accepts_nested_attributes_for :images, :allow_destroy => true
  accepts_nested_attributes_for :webpages, :allow_destroy => true
  
  before_validation_on_create { |place|
    #set the image from flickr if no images are set
    if place.images.empty? or place.images.first.url.empty?
      place.images = []
      place.add_image_from_flickr 
    end
  }
  
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
  
  def add_image_from_flickr
    potential_images = potential_images({:max => 1})
    
    unless potential_images.empty?
      img = self.images.build(:url => potential_images.first )
    end
  end
end

# == Schema Info
# Schema version: 20100510021227
#
# Table name: places
#
#  id          :integer(4)      not null, primary key
#  category_id :integer(4)
#  description :text
#  location    :string(255)
#  name        :string(255)
#  created_at  :datetime
#  updated_at  :datetime