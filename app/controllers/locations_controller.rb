class LocationsController < ApplicationController
  # GET /locations
  # GET /locations.xml
  def index
    # ETags!
    last_updated_location = Location.last(:order => 'updated_at')
    response.last_modified = last_updated_location.updated_at.utc
    response.etag = last_updated_location
    head :not_modified and return if request.fresh?(response)

    @locations = Location.all(:include => {:geocoding => :geocode})
    @location = Location.new(:signs => 'Blue')
  
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @locations.to_json, :callback => params[:callback] }
      format.xml  { render :xml => @locations }
      format.atom
    end
  end

  # GET /locations/1
  # GET /locations/1.xml
  def show
    @location = Location.find(params[:id])
    
    # ETags!
    response.last_modified = @location.updated_at.utc
    response.etag = @location
    head :not_modified and return if request.fresh?(response)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @location }
    end
  end

  # GET /locations/new
  # GET /locations/new.xml
  def new
    @location = Location.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @location }
    end
  end

  # GET /locations/1/edit
  def edit
    @location = Location.find(params[:id])
  end

  # POST /locations
  # POST /locations.xml
  def create
    @location = Location.new(params[:location])

    respond_to do |format|
      if @location.save
        flash[:notice] = 'Location was successfully created.'
        format.html { redirect_to(@location) }
        format.js { render :json => @location.to_json, :callback => params[:callback] || 'mapLocationAndFocus' }
        format.xml  { render :xml => @location, :status => :created, :location => @location }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /locations/1
  # PUT /locations/1.xml
  def update
    @location = Location.find(params[:id])

    respond_to do |format|
      if @location.update_attributes(params[:location])
        flash[:notice] = 'Location was successfully updated.'
        format.html { redirect_to(@location) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.xml
  def destroy
    @location = Location.find(params[:id])
    @location.destroy
    flash[:notice] = 'The location has been removed.'
    
    respond_to do |format|
      format.html { redirect_to(root_path) }
      format.xml  { head :ok }
    end
  end
end
