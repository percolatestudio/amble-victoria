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
end
