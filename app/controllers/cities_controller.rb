class CitiesController < ApplicationController
  def index
    @cities = Location.with_geocodes.all(:group => 'city, state')
    
    respond_to do |format|
      format.json { render :json => @cities.to_json(:methods => :city_info), :callback => params[:callback] }
    end
  end
end
