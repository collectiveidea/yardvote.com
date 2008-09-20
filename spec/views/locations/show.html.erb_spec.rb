require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/locations/show.html.erb" do
  include LocationsHelper
  
  before(:each) do
    assigns[:location] = @location = stub_model(Location,
      :street => "value for street",
      :city => "value for city",
      :state => "value for state",
      :zip => "value for zip",
      :signs => "value for signs"
    )
  end

  it "should render attributes in <p>" do
    render "/locations/show.html.erb"
    response.should have_text(/value\ for\ street/)
    response.should have_text(/value\ for\ city/)
    response.should have_text(/value\ for\ state/)
    response.should have_text(/value\ for\ zip/)
    response.should have_text(/value\ for\ signs/)
  end
end

