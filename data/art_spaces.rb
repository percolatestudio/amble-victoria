#!/usr/bin/ruby
require 'base'
require 'csv'

class ArtSpaces < Base
  def filename
    'art_spaces.csv'
  end
  
  def normalize
    reader = CSV.open(filename, 'r') 
    reader.shift # headers
    reader.each do |row| # Organisation,Street,Suburb/Town,Postcode,Website            
      r = {}
      r[:category_name] = 'Art Spaces'
      r[:source_name] = 'Art Spaces Gov Data'
            
      r[:name] = row[0].to_s
      r[:location] = "#{row[1]}, #{row[2]}, #{row[3]}"
      r[:webpages_attributes] = [{:url => row[4].to_s}]
          
      @records << r
    end
  end
end

Base.main(ArtSpaces.new)