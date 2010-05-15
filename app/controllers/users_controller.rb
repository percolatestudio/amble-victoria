class UsersController < ApplicationController
  layout 'xhr'
  
  before_filter :require_user, :only => :show
    
  def loading
    render :layout => 'mobile'
  end
end
