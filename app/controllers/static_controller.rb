class StaticController < ApplicationController
  def home
    redirect_to explore_url if is_mobile_device?
  end
    
  def test
    current_navigation :explore
    
    respond_to do |format|
      format.html 
      format.mobile { return render :action => 'test.html.erb' }
    end
  end
  
end
