# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  # protect_from_forgery # See ActionController::RequestForgeryProtection for details

  helper_method :current_user_session, :current_user
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

private
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end
  
  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to user_path(current_user)
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
  
  # our standard rendering behaviour for views
  #   1. we are going to be dynamically loaded into div#content
  #   2. we render by ourself as webpage
  #   3. we render for some API call or something
  def render_standard(options = {})
    data = options.delete(:data)
    
    if request.xhr? or params[:xhr]
      render options.merge(:layout => 'xhr')
    else
      respond_to do |format|
        format.html { render options.merge(:layout => 'website') }
        
        unless data.nil?
          format.xml  { render options.merge(:xml  => data) }
          format.json { render options.merge(:json => data) }
        end
      end
    end
  end
end
