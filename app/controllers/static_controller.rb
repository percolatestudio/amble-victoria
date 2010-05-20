class StaticController < ApplicationController
  def test
    render_standard :action => 'test.html.erb'
  end
end
