class StaticController < ApplicationController
  def home
    redirect_to explore_url if is_mobile_device?
  end
    
  def test
    render_standard :action => 'test.html.erb'
  end
end
