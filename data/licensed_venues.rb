#!/usr/bin/ruby
require 'base'
require 'csv'

class ArtSpaces < Base
  def filename
    'licensed_venues.csv'
  end
  
  def normalize
    reader = CSV.open(filename, 'r') 
    reader.shift # headers
    reader.each do |row| # LicenceNo,LicenceType,PremisesName,Licensee,Address1,Address2,Suburb,Postcode
      if row[1] == "Restaurant & Caf\351"
        r = {}
        r[:category_name] = 'Restaurants or Cafe'
        r[:source_name] = 'Licensed Venues Gov Data'
            
        r[:name] = capitalize_words(row[2].to_s)
        r[:location] = join_address(row, 4, 7)
          
        @records << r
      end
    end
  end
end

Base.main(ArtSpaces.new)