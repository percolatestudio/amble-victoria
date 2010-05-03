# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

categories = [{:name => 'Museums'},
              {:name => 'Art Galleries'},
              {:name => 'Landmark'},
              {:name => 'Other'}]

categories.each { |category| Category.find_or_create_by_name(category) }

places = [
  {:name => 'National Gallery of Victoria', :location => '180 St Kilda Road, Melbourne.  Victoria.  3004', 
    :url => 'http://www.ngv.vic.gov.au/', :category => Category.find_by_name('Art Galleries'),
    :description => "Founded in 1861, it is the oldest and the largest public art gallery in Australia. The main gallery is located in St Kilda Road, in the heart of the Melbourne Arts Precinct of Southbank, with a branch gallery at Federation Square.\n\nThe International Collection includes works by Gian Lorenzo Bernini, Marco Palmezzano, Rembrandt, Peter Paul Rubens, Giovanni Battista Tiepolo, Tintoretto, Paolo Uccello, and Paolo Veronese, amongst others. In the Modern collection, the gallery has continued to expand into new areas, becoming an early leader in textiles, fashion, photography, and Australian Aboriginal art. Today it has strong collections in areas as diverse as old masters, Greek vases, Egyptian artefacts and historical European ceramics, and the largest and most comprehensive range of artworks in Australia."},
  {:name => 'Flinders Street Station', :location => "Corner of Flinders and Swanston St, Melbourne.  Victoria.  3000", 
    :url => '', :category => Category.find_by_name('Landmark'),
    :description => "Flinders Street Station is the central railway station of the suburban rail network of Melbourne, Australia.\n\nEach weekday, over 110,000 commuters[1] and 1,500 trains pass through the station. Flinders Street is serviced by Metro's suburban services, and V/Line regional services to Gippsland.\n\nThe Melburnian idiom \"I'll meet you under the clocks\" refers to the row of clocks above the main entrance, which indicate the departure time of the next train on each line; another being \"I'll meet you on the steps\", referring to the wide staircase leading into the main entrance of Flinders Street Station. Both are a popular meeting places as it is at the intersection of two of the city's busiest thoroughfares. The station is listed on the Victorian Heritage Register."}
  ]
  
places.each { |place| Place.find_or_create_by_name(place) }  
