require 'spec_helper'

describe MapFiltersController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/map_filters" }.should route_to(:controller => "map_filters", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/map_filters/new" }.should route_to(:controller => "map_filters", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/map_filters/1" }.should route_to(:controller => "map_filters", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/map_filters/1/edit" }.should route_to(:controller => "map_filters", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/map_filters" }.should route_to(:controller => "map_filters", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/map_filters/1" }.should route_to(:controller => "map_filters", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/map_filters/1" }.should route_to(:controller => "map_filters", :action => "destroy", :id => "1") 
    end
  end
end
