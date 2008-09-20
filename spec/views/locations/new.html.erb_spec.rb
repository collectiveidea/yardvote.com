require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/locations/new.html.erb" do
  include LocationsHelper
  
  before(:each) do
    assigns[:location] = stub_model(Location,
      :new_record? => true,
      :street => "value for street",
      :city => "value for city",
      :state => "value for state",
      :zip => "value for zip",
      :signs => "value for signs"
    )
  end

  it "should render new form" do
    render "/locations/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", locations_path) do
      with_tag("input#location_street[name=?]", "location[street]")
      with_tag("input#location_city[name=?]", "location[city]")
      with_tag("input#location_state[name=?]", "location[state]")
      with_tag("input#location_zip[name=?]", "location[zip]")
      with_tag("select#location_signs[name=?]", "location[signs]")
    end
  end
end


