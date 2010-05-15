# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

categories = [
              {:name => 'Museums'},
              {:name => 'Art Galleries'},
              {:name => 'Landmark'},
              {:name => 'Other'}
             ]

categories.each { |category| Category.find_or_create_by_name(category) }

places = [
  {:name => 'National Gallery of Victoria', :location => '180 St Kilda Road, Melbourne.  Victoria.  3004', :category => Category.find_by_name('Art Galleries'),
   :description => "Founded in 1861, it is the oldest and the largest public art gallery in Australia. The main gallery is located in St Kilda Road, in the heart of the Melbourne Arts Precinct of Southbank, with a branch gallery at Federation Square.\n\nThe International Collection includes works by Gian Lorenzo Bernini, Marco Palmezzano, Rembrandt, Peter Paul Rubens, Giovanni Battista Tiepolo, Tintoretto, Paolo Uccello, and Paolo Veronese, amongst others. In the Modern collection, the gallery has continued to expand into new areas, becoming an early leader in textiles, fashion, photography, and Australian Aboriginal art. Today it has strong collections in areas as diverse as old masters, Greek vases, Egyptian artefacts and historical European ceramics, and the largest and most comprehensive range of artworks in Australia."},
  {:name => 'Flinders Street Station', :location => "Corner of Flinders and Swanston St, Melbourne.  Victoria.  3000", :category => Category.find_by_name('Landmark'),
    :description => "Flinders Street Station is the central railway station of the suburban rail network of Melbourne, Australia.\n\nEach weekday, over 110,000 commuters[1] and 1,500 trains pass through the station. Flinders Street is serviced by Metro's suburban services, and V/Line regional services to Gippsland.\n\nThe Melburnian idiom \"I'll meet you under the clocks\" refers to the row of clocks above the main entrance, which indicate the departure time of the next train on each line; another being \"I'll meet you on the steps\", referring to the wide staircase leading into the main entrance of Flinders Street Station. Both are a popular meeting places as it is at the intersection of two of the city's busiest thoroughfares. The station is listed on the Victorian Heritage Register."},
  {:name => 'Federation Square', :location => 'Federation Square, Melbourne. Victoria',:category => Category.find_by_name('Landmark')},
  {:name => 'Southbank', :location => 'Southbank, Melbourne. Victoria', :category => Category.find_by_name('Landmark')},
  {:name => 'Brunswick Street', :location => 'Brunswick St, Melbourne. Victoria', :category => Category.find_by_name('Landmark')},
  {:name => 'Luna Park', :location => 'Luna Park, St Kilda, Melbourne. Victoria', :category => Category.find_by_name('Landmark')}
  ]
  
db_places = places.collect { |place| Place.find_or_create_by_name(place) }
db_places.each {|place| place.primary_image = place.images.first; place.save! }

sources = [
  {:name => 'Flickr', :url => 'http://www.flickr.com/', :icon_filename => 'flickr.jpg'},
  {:name => 'Wikipedia', :url => 'http://wikipedia.org/', :icon_filename => 'wikipedia.jpg'}
  ]
  
sources.each { |source| Source.find_or_create_by_name(source) }

webpages = [
  {:url => 'http://www.ngv.vic.gov.au/', :place => Place.find_by_name('National Gallery of Victoria') }, 
  {:url => 'http://en.wikipedia.org/wiki/National_Gallery_of_Victoria', :place => Place.find_by_name('National Gallery of Victoria'), :source => Source.find_by_name('wikipedia') }
]

webpages.each { |webpage| Webpage.find_or_create_by_url(webpage) }
