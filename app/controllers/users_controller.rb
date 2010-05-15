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
      session[:location] = set_location(params[:location][:latitude], params[:location][:longitude])
    else
      set_location_automatically
    end
    
    logger.info "set location to: #{session[:location].inspect}"
    
    if request.xhr?
      render :text => ''
    else
      render :layout => 'website'
    end
  end
end
