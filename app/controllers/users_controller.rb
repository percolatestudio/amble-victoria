class UsersController < ApplicationController
  layout 'content'
  before_filter :require_user
  
  def loading
    render :layout => 'application'
  end
  
end
