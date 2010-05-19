module PlacesHelper
  def setup_place(place)
    returning(place) do |p|
      p.images.build if p.images.empty?
      p.webpages.build if p.webpages.empty?
    end
  end
  
  def save_button(place)
    if logged_in? and not current_user.saved? place
      link_to 'Save', save_place_path(place)
    else
      link_to 'UnSave', unsave_place_path(place)
    end  
  end
  
  def saved_class(place)
    'saved' if logged_in? and current_user.saved? place
  end
  
  def map_img_url(place, size="200x100")
    "http://maps.google.com/maps/api/staticmap?zoom=14&" + 
      "size=#{size}&sensor=true&" +
      "markers=color:blue|label:A|#{place.lat},#{place.lng}"
  end
  
  def map_img_url_with_origin(place, size="200x200")
    location = {:lat => -37.817455, :lng => 144.96745}
    
    "http://maps.google.com/maps/api/staticmap?center=#{location[:lat]},#{location[:lng]}&" + 
      "size=#{size}&sensor=true&" +
      "markers=color:red|label:A|#{place.lat},#{place.lng}&" +
      "markers=color:blue|size:tiny|#{location[:lat]},#{location[:lng]}"
  end

  def format_location(location)
    location.sub(",", ",<br />")
  end
  
  def format_distance(distance)
    if distance.to_f < 500
      number_with_precision(distance, :precision => 1) + ' km'
    else
      'Far'
    end
  end
  
end
