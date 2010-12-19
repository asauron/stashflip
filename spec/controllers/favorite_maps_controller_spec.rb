require 'spec_helper'

describe FavoriteMapsController do

  def mock_favorite_map(stubs={})
    @mock_favorite_map ||= mock_model(FavoriteMap, stubs)
  end

  describe "GET index" do
    it "assigns all favorite_maps as @favorite_maps" do
      FavoriteMap.stub(:find).with(:all).and_return([mock_favorite_map])
      get :index
      assigns[:favorite_maps].should == [mock_favorite_map]
    end
  end

  describe "GET show" do
    it "assigns the requested favorite_map as @favorite_map" do
      FavoriteMap.stub(:find).with("37").and_return(mock_favorite_map)
      get :show, :id => "37"
      assigns[:favorite_map].should equal(mock_favorite_map)
    end
  end

  describe "GET new" do
    it "assigns a new favorite_map as @favorite_map" do
      FavoriteMap.stub(:new).and_return(mock_favorite_map)
      get :new
      assigns[:favorite_map].should equal(mock_favorite_map)
    end
  end

  describe "GET edit" do
    it "assigns the requested favorite_map as @favorite_map" do
      FavoriteMap.stub(:find).with("37").and_return(mock_favorite_map)
      get :edit, :id => "37"
      assigns[:favorite_map].should equal(mock_favorite_map)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created favorite_map as @favorite_map" do
        FavoriteMap.stub(:new).with({'these' => 'params'}).and_return(mock_favorite_map(:save => true))
        post :create, :favorite_map => {:these => 'params'}
        assigns[:favorite_map].should equal(mock_favorite_map)
      end

      it "redirects to the created favorite_map" do
        FavoriteMap.stub(:new).and_return(mock_favorite_map(:save => true))
        post :create, :favorite_map => {}
        response.should redirect_to(favorite_map_url(mock_favorite_map))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved favorite_map as @favorite_map" do
        FavoriteMap.stub(:new).with({'these' => 'params'}).and_return(mock_favorite_map(:save => false))
        post :create, :favorite_map => {:these => 'params'}
        assigns[:favorite_map].should equal(mock_favorite_map)
      end

      it "re-renders the 'new' template" do
        FavoriteMap.stub(:new).and_return(mock_favorite_map(:save => false))
        post :create, :favorite_map => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested favorite_map" do
        FavoriteMap.should_receive(:find).with("37").and_return(mock_favorite_map)
        mock_favorite_map.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :favorite_map => {:these => 'params'}
      end

      it "assigns the requested favorite_map as @favorite_map" do
        FavoriteMap.stub(:find).and_return(mock_favorite_map(:update_attributes => true))
        put :update, :id => "1"
        assigns[:favorite_map].should equal(mock_favorite_map)
      end

      it "redirects to the favorite_map" do
        FavoriteMap.stub(:find).and_return(mock_favorite_map(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(favorite_map_url(mock_favorite_map))
      end
    end

    describe "with invalid params" do
      it "updates the requested favorite_map" do
        FavoriteMap.should_receive(:find).with("37").and_return(mock_favorite_map)
        mock_favorite_map.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :favorite_map => {:these => 'params'}
      end

      it "assigns the favorite_map as @favorite_map" do
        FavoriteMap.stub(:find).and_return(mock_favorite_map(:update_attributes => false))
        put :update, :id => "1"
        assigns[:favorite_map].should equal(mock_favorite_map)
      end

      it "re-renders the 'edit' template" do
        FavoriteMap.stub(:find).and_return(mock_favorite_map(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested favorite_map" do
      FavoriteMap.should_receive(:find).with("37").and_return(mock_favorite_map)
      mock_favorite_map.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the favorite_maps list" do
      FavoriteMap.stub(:find).and_return(mock_favorite_map(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(favorite_maps_url)
    end
  end

end
