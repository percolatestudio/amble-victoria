class UsersController < ApplicationController
  layout 'content'
  
  before_filter :require_user, :only => :show
    
  def loading
    render :layout => 'iphone'
  end
end
