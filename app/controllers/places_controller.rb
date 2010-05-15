class PlacesController < ApplicationController
  layout 'xhr'
    
  # GET /places
  # GET /places.xml
  def index
    source = if params[:user_id]
      User.find(params[:user_id]).places
    else
      Place
    end
    
    @places = source.visible.all
    
    render_standard :data => @places
  end

  # GET /places/1
  # GET /places/1.xml
  def show
    @place = Place.find(params[:id])
    
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
