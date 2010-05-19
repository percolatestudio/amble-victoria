class PlacesController < ApplicationController
  layout 'xhr'
    
  # GET /places
  # GET /places.xml
  
  #location
  
  PLACE_FILTER = Struct.new(:category_id, :location)
  
  def index
    source = if params[:user_id]
      @user = User.find(params[:user_id])
      @user.saved_places
    else
      Place
    end
    
    @place_filter = PLACE_FILTER.from_hash(params[:place_filter])
    
    logger.warn "params[:place_filter]: #{params[:place_filter].inspect}"

    if (!@place_filter[:location].nil?) && (!@place_filter[:location].empty?)
      set_location_from_address(@place_filter[:location])
    end
    
    unless origin_exists?
      render_standard :action => 'none_exist'
      return
    end
    
    
    #turn locaiton into long/lat, if that fails (i.e. they're nil)
      #render location_not_found text
    
    #need validation around the 
    
    #into place model, put:
      #find_by_place_filter  
      
    #have to update session[:location]
      
    #need to update the user's location first (i.e. origion)
    
    
    @places = source.visible.all :origin => origin
    #@places = source.visible.all(:origin => origin, :conditions => nil)
    #@places = source.visible.all(:origin => origin)
    
    #@places = source.visible.all :origin => origin, :conditions => {}
    
    render_standard :data => @places
  end

  # GET /places/1
  # GET /places/1.xml
  def show
    @place = Place.find(params[:id], :origin => origin)
    
    render_standard :data => @place
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

public
  
  def quickedit
    if request.put?
      @place = Place.find(params[:id])
      
      if @place.update_attributes(params[:place])
        flash[:notice] = 'Place was successfully updated.'
      else
        render :layout => 'website'
        return
      end
    end

    #sorting by rand() will be slow for large datasets, but should
    #be fine for us to begin with
    @place = Place.invisible.find(:first, :order => 'rand()')    
    
    if @place.nil?
      render :text => 'no places found that can be quickedited'
    else
      render :layout => 'website'
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
