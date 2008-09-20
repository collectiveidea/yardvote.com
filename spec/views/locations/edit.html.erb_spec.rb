require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/locations/edit.html.erb" do
  include LocationsHelper
  
  before(:each) do
    assigns[:location] = @location = stub_model(Location,
      :new_record? => false,
      :street => "value for street",
      :city => "value for city",
      :state => "value for state",
      :zip => "value for zip",
      :signs => "value for signs"
    )
  end

  it "should render edit form" do
    render "/locations/edit.html.erb"
    
    response.should have_tag("form[action=#{location_path(@location)}][method=post]") do
      with_tag('input#location_street[name=?]', "location[street]")
      with_tag('input#location_city[name=?]', "location[city]")
      with_tag('input#location_state[name=?]', "location[state]")
      with_tag('input#location_zip[name=?]', "location[zip]")
      with_tag('select#location_signs[name=?]', "location[signs]")
    end
  end
end


