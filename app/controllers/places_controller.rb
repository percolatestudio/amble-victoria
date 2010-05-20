class PlacesController < ApplicationController

  before_filter :require_location, :only => [:index, :show]
  before_filter :require_admin, :only => [:new, :edit, :quickedit,
    :create, :update, :destroy]
  
  # GET /places
  # GET /places.xml
  
  PLACE_FILTER = Struct.new(:category_id, :location)
  
  def index
    current_navigation :places
    
    if params[:place_filter]
      @place_filter = PLACE_FILTER.from_hash(params[:place_filter])
    else
      @place_filter = PLACE_FILTER.from_hash({:location => location[:str]})
    end
    
    #update location
    if (!@place_filter[:location].nil?) && (!@place_filter[:location].empty?)
      unless set_location_from_address(@place_filter[:location])
        @place_filter[:location] = location[:str]
        
        if request.xhr?
          render :text => 'Unable to find specified location', :status => :unprocessable_entity
        else
          render :action => 'none_exist', :layout => 'mobile'
        end

        return
      end
    end

    unless @place_filter[:category_id].nil? or @place_filter[:category_id] == ""
      conditions = ['category_id = ?', @place_filter[:category_id]]
    end
    
    @places = Place.visible.paginate(:page => params[:page], :origin => origin, 
      :conditions => conditions || "", :order => 'distance')
    
    if request.xhr? and not params[:page].nil?
      # paginated request
      render :partial => 'paginated', :locals => {:places => @places}
    else
      render_standard :data => @places, :action => 'index.html'
    end
  end

  def show
    if request.referer =~ /my_places/
      current_navigation :my_places
    else
      current_navigation :explore
    end
    
    @place = Place.find(params[:id], :origin => origin)
    
    render_standard :data => @place, :action => 'show.html'
  end

  # GET /places/new
  # GET /places/new.xml
  def new
    @place = Place.new
    
    render_standard :data => @place
  end
  
  # GET /places/1/edit
  def edit
    @place = Place.find(params[:id])
    
    render_standard :data => @place
  end
  
  def save
    return visit_needs_logged_in unless logged_in?
    
    @place = Place.find(params[:id])
    if (@visit = current_user.visits.find_by_place_id(params[:id]))
      @visit.saved = true
    else
      @visit = current_user.visits.new(:place => @place)
    end

    if @visit.save
      flash[:notice] = 'Visit was successfully saved.'
      update_visit_response(:ok)
    else
      flash[:notice] = 'There was a problem saving the visit.'
      update_visit_response(:unprocessable_entity)
    end
  end
  
  def unsave
    return visit_needs_logged_in unless logged_in?
    
    @visit = current_user.visits.saved.find_by_place_id(params[:id])
    
    if @visit.update_attributes(:saved => false)
      flash[:notice] = 'Visit was successfully removed.'
      update_visit_response(:ok)
    else
      flash[:notice] = 'There was a problem removing the visit.'
      update_visit_response(:unprocessable_entity)
    end
  end
  
private
  # deal properly with the above two methods
  def update_visit_response(status)
    if request.xhr?
      head :status => status
    else
      respond_to do |format|
        # send 'em back to where they came from
        format.html { redirect_to request.headers['HTTP_REFERER'] }
      end
    end
  end
  
  def visit_needs_logged_in
    flash[:error] = 'You must be logged in to save places.'
    if request.xhr?
      render :text => new_user_session_path, :status => :unauthorized
    else
      require_user
    end
  end
public
  
  def quickedit
    if request.put?
      @place = Place.find(params[:id])
      
      if @place.update_attributes(params[:place])
        flash[:notice] = 'Place was successfully updated.'
      else
        return render :layout => 'application'
      end
    end

    #sorting by rand() will be slow for large datasets, but should
    #be fine for us to begin with
    @place = Place.invisible.find(:first, :order => 'rand()')    
    
    if @place.nil?
      return render :text => 'no places found that can be quickedited'
    else
      return render :layout => 'application'
    end
  end

  # POST /places
  # POST /places.xml
  def create
    @place = Place.new(params[:place])

    respond_to do |format|
      if @place.save
        flash[:notice] = 'Place was successfully created.'
        format.html { redirect_to(@place) }
        format.xml  { render :xml => @place, :status => :created, :location => @place }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @place.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /places/1
  # PUT /places/1.xml
  def update
    @place = Place.find(params[:id])

    respond_to do |format|
      if @place.update_attributes(params[:place])
        flash[:notice] = 'Place was successfully updated.'
        format.html { redirect_to(@place) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @place.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /places/1
  # DELETE /places/1.xml
  def destroy
    @place = Place.find(params[:id])
    @place.destroy

    respond_to do |format|
      format.html { redirect_to(places_url) }
      format.xml  { head :ok }
    end
  end  
end
