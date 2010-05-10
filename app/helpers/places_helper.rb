module PlacesHelper
  def setup_place(place)
    returning(place) do |p|
      p.images.build if p.images.empty?
      p.webpages.build if p.webpages.empty?
    end
    
  end
end
