# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

categories = [
              {:name => 'Museum'},
              {:name => 'Art Space'},
              {:name => 'Landmark'},
              {:name => 'Restaurant or Cafe'},
              {:name => 'Other'}
             ]

categories.each { |category| Category.find_or_create_by_name(category) }

sources = [
  {:name => 'Flickr', :url => 'http://www.flickr.com/', :icon_filename => 'flickr.jpg'},
  {:name => 'Wikipedia', :url => 'http://wikipedia.org/', :icon_filename => 'wikipedia.jpg'},
  {:name => 'Art Spaces Gov Data', :url => 'http://data.vic.gov.au/raw_data/arts-spaces-and-places/46'},
  {:name => 'Licensed Venues Gov Data', :url => 'http://data.vic.gov.au/raw_data/licenced-venues/51'},
  {:name => 'Tourism Vic Gov Data', :url => 'http://data.vic.gov.au/data_tool/tourism-victoria-atdw-data-set/153'}
  ]
  
sources.each { |source| Source.find_or_create_by_name(source) }