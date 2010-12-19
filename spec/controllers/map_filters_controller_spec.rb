require 'spec_helper'

describe MapFiltersController do

  def mock_map_filter(stubs={})
    @mock_map_filter ||= mock_model(MapFilter, stubs)
  end

  describe "GET index" do
    it "assigns all map_filters as @map_filters" do
      MapFilter.stub(:find).with(:all).and_return([mock_map_filter])
      get :index
      assigns[:map_filters].should == [mock_map_filter]
    end
  end

  describe "GET show" do
    it "assigns the requested map_filter as @map_filter" do
      MapFilter.stub(:find).with("37").and_return(mock_map_filter)
      get :show, :id => "37"
      assigns[:map_filter].should equal(mock_map_filter)
    end
  end

  describe "GET new" do
    it "assigns a new map_filter as @map_filter" do
      MapFilter.stub(:new).and_return(mock_map_filter)
      get :new
      assigns[:map_filter].should equal(mock_map_filter)
    end
  end

  describe "GET edit" do
    it "assigns the requested map_filter as @map_filter" do
      MapFilter.stub(:find).with("37").and_return(mock_map_filter)
      get :edit, :id => "37"
      assigns[:map_filter].should equal(mock_map_filter)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created map_filter as @map_filter" do
        MapFilter.stub(:new).with({'these' => 'params'}).and_return(mock_map_filter(:save => true))
        post :create, :map_filter => {:these => 'params'}
        assigns[:map_filter].should equal(mock_map_filter)
      end

      it "redirects to the created map_filter" do
        MapFilter.stub(:new).and_return(mock_map_filter(:save => true))
        post :create, :map_filter => {}
        response.should redirect_to(map_filter_url(mock_map_filter))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved map_filter as @map_filter" do
        MapFilter.stub(:new).with({'these' => 'params'}).and_return(mock_map_filter(:save => false))
        post :create, :map_filter => {:these => 'params'}
        assigns[:map_filter].should equal(mock_map_filter)
      end

      it "re-renders the 'new' template" do
        MapFilter.stub(:new).and_return(mock_map_filter(:save => false))
        post :create, :map_filter => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested map_filter" do
        MapFilter.should_receive(:find).with("37").and_return(mock_map_filter)
        mock_map_filter.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :map_filter => {:these => 'params'}
      end

      it "assigns the requested map_filter as @map_filter" do
        MapFilter.stub(:find).and_return(mock_map_filter(:update_attributes => true))
        put :update, :id => "1"
        assigns[:map_filter].should equal(mock_map_filter)
      end

      it "redirects to the map_filter" do
        MapFilter.stub(:find).and_return(mock_map_filter(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(map_filter_url(mock_map_filter))
      end
    end

    describe "with invalid params" do
      it "updates the requested map_filter" do
        MapFilter.should_receive(:find).with("37").and_return(mock_map_filter)
        mock_map_filter.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :map_filter => {:these => 'params'}
      end

      it "assigns the map_filter as @map_filter" do
        MapFilter.stub(:find).and_return(mock_map_filter(:update_attributes => false))
        put :update, :id => "1"
        assigns[:map_filter].should equal(mock_map_filter)
      end

      it "re-renders the 'edit' template" do
        MapFilter.stub(:find).and_return(mock_map_filter(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested map_filter" do
      MapFilter.should_receive(:find).with("37").and_return(mock_map_filter)
      mock_map_filter.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the map_filters list" do
      MapFilter.stub(:find).and_return(mock_map_filter(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(map_filters_url)
    end
  end

end
