# we (carefully) extend ruby base classes here

class Struct
  # this allows a struct to create an instance of it's class from a hash
  # e.g instead of Struct.new(:foo).new(bar)
  # you can do: Struct.new(:foo).from_hash({:foo => bar})
  #
  # attributes that are present in the hash and not in the struct will
  # throw an exception  
  def self.from_hash(h)
    obj = new
    
    h.keys.each {|k| obj[k] = h[k] } unless h.nil?
    
    obj
   end
   
   # go the other way (could have a keys argument i guess)
   def to_hash
     h = {}
     each_pair { |k,v| h[k] = v }
     h
   end
end

class Array
  # kludge to deal with actionview's annoyances
  # similar to extract_options! but specifiy where you think the option should be
  def extract_options_at!(index)
    if index == :last
      self.extract_options!
    else
      self.length > index ? self.slice!(index) : {}
    end
  end
  
  def insert_options_at!(index, opts)
    if index == :last
      self << opts
    else
      self[index,0] = opts
    end
  end
  
  # flattens and returns the array as a hash
  # after flattening, array should look something like:
  # [1, 'a', 2, 'b'...] which will become {1 => 'a', 2 => 'b'}
  def to_hash
    Hash[*flatten]
  end
end