class UsersController < ApplicationController
  layout 'xhr'
  
  before_filter :require_user, :only => [:show, :places, :my_places, :account]
  
  # Please change this is you can think of a better way to do this. 
  #  we need these actions so we can link to them before we have a current user
  def my_places
    # UserSession.find
    redirect_to user_places_path(current_user)
  end
  
  def account
    redirect_to user_path(current_user)
  end
  
    
  def loading
    render :layout => 'mobile'
  end

  def update_location
    if params[:location]
      location = params[:location]
    else
      geo_location = GeoKit::Geocoders::MultiGeocoder.geocode(request.remote_ip)      
      
      if geo_location.success
        location = {:lat => location.lat, :lng => location.lng}
      else
        location = DEFAULT_LOCATION
      end
    end
    
    session[:location] = location.merge({:current => true})
    logger.info "set location to: #{session[:location].inspect}"
    
    if request.xhr?
      render :text => ''
    else
      render :layout => 'website'
    end
  end
end
