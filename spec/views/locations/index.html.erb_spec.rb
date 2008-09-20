require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/locations/index.html.erb" do
  include LocationsHelper
  
  before(:each) do
    assigns[:locations] = [
      stub_model(Location,
        :street => "value for street",
        :city => "value for city",
        :state => "value for state",
        :zip => "value for zip",
        :signs => "value for signs"
      ),
      stub_model(Location,
        :street => "value for street",
        :city => "value for city",
        :state => "value for state",
        :zip => "value for zip",
        :signs => "value for signs"
      )
    ]
  end

  it "should render list of locations" do
    render "/locations/index.html.erb"
    response.should have_tag("tr>td", "value for street", 2)
    response.should have_tag("tr>td", "value for city", 2)
    response.should have_tag("tr>td", "value for state", 2)
    response.should have_tag("tr>td", "value for zip", 2)
    response.should have_tag("tr>td", "value for signs", 2)
  end
end

