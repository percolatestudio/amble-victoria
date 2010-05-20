class StaticController < ApplicationController
  def test
    respond_to do |format|
      format.html 
      format.mobile { return render :action => 'test.html.erb' }
    end
  end
end
