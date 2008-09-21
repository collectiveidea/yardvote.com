require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LocationsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "locations", :action => "index").should == "/locations"
    end
  
    it "should map #new" do
      route_for(:controller => "locations", :action => "new").should == "/locations/new"
    end
  
    it "should map #show" do
      route_for(:controller => "locations", :action => "show", :id => 1).should == "/locations/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "locations", :action => "edit", :id => 1).should == "/locations/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "locations", :action => "update", :id => 1).should == "/locations/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "locations", :action => "destroy", :id => 1).should == "/locations/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/locations").should == {:controller => "locations", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/locations/new").should == {:controller => "locations", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/locations").should == {:controller => "locations", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/locations/1").should == {:controller => "locations", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/locations/1/edit").should == {:controller => "locations", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/locations/1").should == {:controller => "locations", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/locations/1").should == {:controller => "locations", :action => "destroy", :id => "1"}
    end
  end
end
