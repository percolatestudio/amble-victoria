class Place < ActiveRecord::Base
  acts_as_mappable
  
  belongs_to :category
  has_many :webpages
  has_many :images
  belongs_to :primary_image, :class_name => 'Image'
  belongs_to :source # where the data came from
  
  has_many :visits
  has_many :users, :through => :visits
  
  validates_presence_of :name
  validates_presence_of :location  
  validates_presence_of :category_id
  
  validates_numericality_of :lng
  validates_numericality_of :lat
  
  validates_presence_of :images
  validates_associated :images
  
  validates_uniqueness_of :name
  
  validates_numericality_of :system_quality, :allow_nil => true, :less_than_or_equal_to => 10, :greater_than_or_equal_to => 0
  validates_numericality_of :user_quality, :allow_nil => true, :less_than_or_equal_to => 10, :greater_than_or_equal_to => 0  
  
  accepts_nested_attributes_for :images, :allow_destroy => true
  accepts_nested_attributes_for :webpages, :allow_destroy => true
  accepts_nested_attributes_for :source, :allow_destroy => true  
  
  named_scope :visible, :conditions => ['primary_image_id IS NOT NULL AND (user_quality is null OR user_quality != 0)']
  named_scope :invisible, :conditions => ['primary_image_id IS NULL OR user_quality = 0']
  
  before_validation :set_coords_from_address
  
  before_save :set_qualities
  
  before_validation_on_create { |place|
    #set the image from flickr if no images are set
    if place.images.empty? or place.images.first.url.empty?
      place.add_images_from_flickr 
    end
  }
  
  #return url's of creative common licensed pictures from flickr for this place
  def potential_images(opts = {:max => 1})
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
  
  def add_images_from_flickr(number = 3)
    potential_images = potential_images({:max => number})
    
    unless potential_images.empty?
      self.images = []
      potential_images.each do |url|
        self.images << Image.create(:url => url)
      end
    end
  end
  
  # take a filename and create a bunch of records
  def self.import_normalized(filename)
    records = YAML.load_file(filename)
    records.each do |r| 
      r[:source] = Source.find_by_name(r.delete(:source_name))
      r[:category] = Category.find_by_name(r.delete(:category_name))
      p = Place.create(r)
      
      if p.valid?
        p.decorate!
      else
        logger.warn "Can't import place: #{p.name}, errors #{p.errors.full_messages.join('\n')}"
      end
    end
  end
  
  def set_coords_from_address
    location = Geokit::Geocoders::MultiGeocoder.geocode(self.location)
    logger.info("location is: #{location.inspect}")
  
    self.lng = location.lng
    self.lat = location.lat
    
    true
  end
  
  # attempt to get some more data off the net about the place
  def decorate!
    # lets use citysearch to find a url + phone for this place
    # but only if its a restaurant
    if self.category.name == 'Restaurant'
      logger.info 'Doing citysearch data load...'
      cs = Citysearch.find(self.location)
      
      unless cs.nil? # we got some results
        self.phone = cs[:phone] if cs[:phone]
        
        if cs[:listing_url]
          wp = Webpage.new(:url => cs[:listing_url])
          wp.source = Source.find_by_name('Citysearch')
          self.webpages = [wp]
          self.save
        end
      end
    end
  end
  
  def set_qualities
    logger.debug "SETTING QUALITIES"
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