require 'spec_helper'

describe FavoriteMapsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/favorite_maps" }.should route_to(:controller => "favorite_maps", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/favorite_maps/new" }.should route_to(:controller => "favorite_maps", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/favorite_maps/1" }.should route_to(:controller => "favorite_maps", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/favorite_maps/1/edit" }.should route_to(:controller => "favorite_maps", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/favorite_maps" }.should route_to(:controller => "favorite_maps", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/favorite_maps/1" }.should route_to(:controller => "favorite_maps", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/favorite_maps/1" }.should route_to(:controller => "favorite_maps", :action => "destroy", :id => "1") 
    end
  end
end
