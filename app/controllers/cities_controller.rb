class CitiesController < ApplicationController
  def index
    last_updated_location = Location.last(:order => 'updated_at')
    response.last_modified = last_updated_location.updated_at.utc
    response.etag = last_updated_location
    head :not_modified and return if request.fresh?(response)
    
    @cities = Location.with_geocodes.in_box(params[:northeast], params[:southwest]).all(:group => 'city, state', :order => 'created_at')
    
    respond_to do |format|
      format.json { render :json => @cities.to_json(:methods => :city_info), :callback => params[:callback] }
    end
  end
end
