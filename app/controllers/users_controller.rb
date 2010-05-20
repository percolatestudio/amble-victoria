class UsersController < ApplicationController
  before_filter :require_user, :only => [:show, :places, :my_places, :account]
  before_filter :require_location, :only => [:my_places]
  
  PLACE_FILTER = Struct.new(:category_id)
  def my_places
    @place_filter = PLACE_FILTER.from_hash(params[:place_filter])
    
    options = {:select => 'places.*', 
      :order => 'visits.updated_at', :origin => origin}
    
    unless @place_filter.category_id.nil?
      options[:conditions] = ['category_id = ?', @place_filter[:category_id]]
    end
    
    @places = current_user.saved_places.all options
    
    render_standard :data => @places, :action => 'my_places.html'
  end
  
    
  def get_location
    current_navigation :explore
    render_standard :action => 'get_location.html'
  end
  
  def update_location
    if params[:location]
      session[:location] = set_location(params[:location][:latitude], params[:location][:longitude])
    else
      set_location_automatically
    end
    
    logger.info "set location to: #{session[:location].inspect}"
    
    redirect_back_or_default(explore_path)
  end
end
