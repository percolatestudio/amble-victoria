class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
  layout 'xhr'
  
  def new
    @user_session = UserSession.new
    logger.warn cookies.to_yaml
    
    render_standard
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    logger.warn cookies.to_yaml
    
    if @user_session.save
      flash[:notice] = "Login successful!"
      
      redirect_back_or_default user_path(@user_session.user)
    else
      logger.warn @user_session.errors.to_yaml
      
      render_standard :action => :new
    end
  end
  
  def destroy
    # do we need to do all this?
    current_user_session.destroy
    clear_facebook_session_information
    # reset_session # i.e. logout the user    
    # cookies.each_key { |k| cookies.delete k}
    
    logger.warn cookies.to_yaml
    flash[:notice] = "Logout successful!"
    redirect_back_or_default account_users_path
  end
end