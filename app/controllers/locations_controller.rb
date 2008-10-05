class LocationsController < ApplicationController
  # GET /locations
  # GET /locations.xml
  def index
    # ETags!
    @last_updated_location = Location.find_with_deleted(:first, :order => 'updated_at DESC')
    response.last_modified = @last_updated_location.updated_at.utc
    response.etag = @last_updated_location
    head :not_modified and return if request.fresh?(response)
  
    respond_to do |format|
      format.html do 
        @locations = Location.with_geocodes.recent.all(params[:all] ? {} : {:limit => 15})
        @location = Location.new(:signs => 'Blue')
      end
      format.json do
        @locations = Location.with_geocodes.in_box(params[:northeast], params[:southwest])
        render :json => {:locations => @locations}, :callback => json_callback
      end
      format.xml do
        @locations = Location.with_geocodes
        render :xml => @locations
      end
      format.atom do
        @locations = Location.with_geocodes.recent        
      end
    end
  end

  def removed
    # ETags!
    @last_updated_location = Location.find_with_deleted(:first, :order => 'updated_at DESC')
    response.last_modified = @last_updated_location.updated_at.utc
    response.etag = @last_updated_location
    head :not_modified and return if request.fresh?(response)
  
    @locations = Location.with_geocodes.recent.find_only_deleted(:all)
  end

  # GET /locations/1
  # GET /locations/1.xml
  def show
    @location = Location.find_with_deleted(params[:id])
    
    # ETags!
    response.last_modified = @location.updated_at.utc
    response.etag = @location
    head :not_modified and return if request.fresh?(response)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => {:focus => @location}, :callback => json_callback }
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
    @location = Location.find_with_deleted(params[:id])
  end

  # POST /locations
  # POST /locations.xml
  def create
    @location = Location.new(params[:location])
    existing = Location.existing_address(@location)

    respond_to do |format|
      if !existing.nil?
        @location = existing
        flash[:notice] = 'Location already exists.'
        format.html { redirect_to @location, :status => 303 }
        format.js { redirect_to formatted_location_path(@location, :format => :json, :callback => json_callback), :status => 303 }
        format.xml  { render :xml => @location, :status => 303, :location => @location }        
      elsif @location.save
        flash[:notice] = 'Location was successfully created.'
        format.html { redirect_to(@location) }
        format.js { render :json => {:focus => @location}, :callback => json_callback }
        format.xml  { render :xml => @location, :status => :created, :location => @location }
      else
        format.html { render :action => "new" }
        format.js  { render :json => {:errors => @location.errors}, :status => :unprocessable_entity, :callback => json_callback}
        format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /locations/1
  # PUT /locations/1.xml
  def update
    @location = Location.find_with_deleted(params[:id])

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
  
  def recover
    @location = Location.find_only_deleted(params[:id])
    @location.recover!
    flash[:notice] = 'The location has been restored.'
    
    respond_to do |format|
      format.html { redirect_to(root_path) }
      format.xml  { head :ok }
    end
  end
  
private

  def json_callback
    params[:callback] || 'Map.callback'
  end
  
end
