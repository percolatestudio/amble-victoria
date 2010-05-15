# 'Abstract' base class for intermedietary format
#
# Format is yaml with params that enable 'Place' models to be built. As such:
#
#  category_name :string -> Maps to seeded categories
#  source_name :string -> Maps to seeded sources
#  description :text -> Relatively brief description
#  location    :string(255) -> Address
#  name        :string(255) -> Title
#  images      :HashOfIndexedHashes
# => image_file_name :string(255)
#    url             :string(255)def 255)
#  webpages     :HashOfIndexedHashes
# => url           :string(255)

require 'yaml'

class Base
  attr_accessor :records
  
  def initialize
    @records = []
  end
  
  def normalize
  end
  
  # should return the name of the input file required
  def filename    
  end
  
  def normalized_filename
    File.basename(self.filename, File.extname(self.filename)) + '.yaml'
  end
  
  def self.main(o)
    puts "normalizing #{o.filename} to #{o.normalized_filename}"
    o.normalize
    
    File.open(o.normalized_filename, 'w' ) { |out| YAML.dump o.records, out }
  end
  
  # eg row[4] .. row[7] contains the address
  def join_address(row, from, to)
    address = from.upto(to).map {|i| row[i].to_s.strip}
    address.delete('')
    capitalize_words(address.join(', '))
  end
  
  # capitalize each word
  def capitalize_words(string)
    string.split(' ').map {|w| w.capitalize }.join(' ')
  end
end