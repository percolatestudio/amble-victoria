# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  helper_method :current_user_session, :current_user, :logged_in?, :origin, :location
  
  has_mobile_fu
  
  layout :select_layout
  
protected

  def location
    session[:location]
  end
  
  def set_location_automatically
    geo_location = GeoKit::Geocoders::MultiGeocoder.geocode(request.remote_ip)      
    
    if geo_location.success
      set_location geo_location.lat, geo_location.lng
    else
      set_location DEFAULT_LOCATION[:lat], DEFAULT_LOCATION[:lng], true
    end
  end
  
  def address_valid?(address)
  end
  
  def set_location_from_address(address)
    location = Geokit::Geocoders::MultiGeocoder.geocode(address)
    return false unless location.success?
    
    session[:location] = {:lat => location.lat, :lng => location.lng, :current => false, :str => location.full_address}
    
    true
  end
  
  def set_location(lat, lng, current = true)
    session[:location] = {:lat => lat, :lng => lng, :current => current}
  end
  
  # this is the origin for the geokit-AR query
  def origin
    [location[:lat], location[:lng]]
  end
  
  def origin_exists?
    return false if location.nil?
    return false if location[:lat].nil?
    return false if location[:lng].nil?
    
    true
  end
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end
  
  def logged_in?
    not current_user.nil?
  end
  
  def require_user
    unless current_user
      store_location
      #flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      #flash[:notice] = "You must be logged out to access this page"
      redirect_to my_places_path
      return false
    end
  end
  
  def require_location
    # special case
    set_location_automatically if request.user_agent =~ /facebookexternalhit/
    
    unless origin_exists?
      store_location
      redirect_to get_location_users_path
      return false
    end
  end
    
  def store_location
    session[:return_to] = request.request_uri
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  def select_layout
    logger.warn '!!!!!!!!!!!!!!selecting layout'
    if request.xhr?
      'xhr'
    elsif is_mobile_device?
      'mobile'
    else
      'application'
    end
  end  
  
  # our standard rendering behaviour for views
  #   1. we are going to be dynamically loaded into div#content
  #   2. we render by ourself as webpage
  #   3. we render for some API call or something
  def render_standard(options = {})
    data = options.delete(:data)
    
    if request.xhr?
      render options.merge(:layout => 'xhr')
    else
      respond_to do |format|
        format.html { render options.merge(:layout => select_layout) }
        format.mobile { render options.merge(:layout => select_layout) }
        
        unless data.nil?
          format.xml  { render options.merge(:xml  => data) }
          format.json { render options.merge(:json => data) }
        end
      end
    end
  end
end
