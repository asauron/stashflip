require 'spec_helper'

describe MapsController do

  def mock_map(stubs={})
    @mock_map ||= mock_model(Map, stubs)
  end
  
  def mock_favoritemap(stubs={})
    @mock_favoritemap ||= mock_model(FavoriteMap, stubs)
  end  
  
  def mock_mapfilter(stubs={})
    @mock_mapfilter ||= mock_model(MapFilter, stubs)
  end
  
  def mock_eventfuldelegate(stubs={})
    @mock_eventfuldelegate ||= mock_model(EventfulDelegate, stubs)
  end
  
  def mock_yelpdelegate(stubs={})
    @mock_yelpdelegate ||= mock_model(YelpDelegate, stubs)
  end    
  
  def mock_gmapdelegate(stubs={})
    @mock_gmapdelegate ||= mock_model(GmapDelegate, stubs)
  end  
  
  def mock_business_list(stubs={})
    @mock_business_list = [{'these'=>'params'}]
  end   
  
  def mock_events_list(stubs={})
    @mock_events_list = [{'these'=>'params'}]
  end   

  describe "GET index" do
    it "assigns all maps as @maps" do
      Map.stub(:find).with(:all).and_return([mock_map])
      get :index
      assigns[:maps].should == [mock_map]
    end
  end

  describe "GET show" do
    it "assigns the requested map as @map" do
      #Map.stub(:find).with("37").and_return(mock_map)
      #get :show, :id => "37"
      #assigns[:map].should equal(mock_map)
    end
  end

  describe "GET new" do
    it "assigns a new map as @map" do
      Map.stub(:new).and_return(mock_map)
      get :new
      assigns[:map].should equal(mock_map)
    end
  end

  describe "GET edit" do
    it "assigns the requested map as @map" do
      Map.stub(:find).with("37").and_return(mock_map)
      get :edit, :id => "37"
      assigns[:map].should equal(mock_map)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created map as @map" do
        Map.stub(:new).with({'these' => 'params'}).and_return(mock_map(:save => true))
        post :create, :map => {:these => 'params'}
        assigns[:map].should equal(mock_map)
      end

      it "redirects to the created map" do
        Map.stub(:new).and_return(mock_map(:save => true))
        post :create, :map => {}
        response.should redirect_to(map_url(mock_map))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved map as @map" do
        Map.stub(:new).with({'these' => 'params'}).and_return(mock_map(:save => false))
        post :create, :map => {:these => 'params'}
        assigns[:map].should equal(mock_map)
      end

      it "re-renders the 'new' template" do
        Map.stub(:new).and_return(mock_map(:save => false))
        post :create, :map => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested map" do
        Map.should_receive(:find).with("37").and_return(mock_map)
        mock_map.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :map => {:these => 'params'}
      end

      it "assigns the requested map as @map" do
        Map.stub(:find).and_return(mock_map(:update_attributes => true))
        put :update, :id => "1"
        assigns[:map].should equal(mock_map)
      end

      it "redirects to the map" do
        Map.stub(:find).and_return(mock_map(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(map_url(mock_map))
      end
    end

    describe "with invalid params" do
      it "updates the requested map" do
        Map.should_receive(:find).with("37").and_return(mock_map)
        mock_map.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :map => {:these => 'params'}
      end

      it "assigns the map as @map" do
        Map.stub(:find).and_return(mock_map(:update_attributes => false))
        put :update, :id => "1"
        assigns[:map].should equal(mock_map)
      end

      it "re-renders the 'edit' template" do
        Map.stub(:find).and_return(mock_map(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested map" do
      Map.should_receive(:find).with("37").and_return(mock_map)
      mock_map.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the maps list" do
      Map.stub(:find).and_return(mock_map(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(maps_url)
    end
  end
  
  describe "search" do
  	it "searches for restaurants using Yelp Delegate" do
  		#create a new mapfilter
  		MapFilter.should_receive(:new).and_return(mock_mapfilter(:category => 'restaurants'))
  		mock_mapfilter.should_receive(:query=).with('pizza')
  		mock_mapfilter.should_receive(:location=).with('berkeley')
  		
  		#soft filter settings
  		mock_mapfilter.should_receive(:num_ratings_weight=).with(nil)
  		mock_mapfilter.should_receive(:avg_rating_weight=).with(nil)
  		mock_mapfilter.should_receive(:cheapness_weight=).with(nil)
  		  		
  		mock_mapfilter.should_receive(:add_nodes=).with("")
  		mock_mapfilter.should_receive(:exclude_nodes=).with("")
  		MapFilter.stub(:getCategory).and_return('restaurants')
  		mock_mapfilter.should_receive(:category=).with('restaurants')
  		#check if category is restaurants, events, shopping, or nightlife
  		mock_mapfilter.should_receive(:category)
  		#call yelp delegate because the category is restaurants
		YelpDelegate.should_receive(:search_by_filter).with(mock_mapfilter).and_return(mock_business_list)
#call gmap delegate because the business list exists
GmapDelegate.should_receive(:getGMap).with(mock_business_list)		
  		get :search, :query => 'pizza', :location => 'berkeley'
  	end  
  	
  	it "searches for events using Eventful Delegate" do
  		#create a new mapfilter  		
  		MapFilter.should_receive(:new).and_return(mock_mapfilter(:category => 'events'))
  		mock_mapfilter.should_receive(:query=).with('golden state warriors')
  		mock_mapfilter.should_receive(:location=).with('oakland')

  		#soft filter settings
  		mock_mapfilter.should_receive(:num_ratings_weight=).with(nil)
  		mock_mapfilter.should_receive(:avg_rating_weight=).with(nil)
  		mock_mapfilter.should_receive(:cheapness_weight=).with(nil)
  		  		
  		mock_mapfilter.should_receive(:add_nodes=).with("")
  		mock_mapfilter.should_receive(:exclude_nodes=).with("")
  		MapFilter.stub(:getCategory).and_return('events')
  		mock_mapfilter.should_receive(:category=).with('events')
  		#check if category is restaurants, events, shopping, or nightlife
  		mock_mapfilter.should_receive(:category)
  		#call eventful delegate because the category is events
		EventfulDelegate.should_receive(:search_by_filter).with(mock_mapfilter).and_return(mock_events_list)
#call gmap delegate because the business list exists
GmapDelegate.should_receive(:getEventGMap).with(mock_events_list)		
  		get :search, :query => 'golden state warriors', :location => 'oakland'
  	end

  	it "searches for shopping using Yelp Delegate" do
  		#create a new mapfilter
  		MapFilter.should_receive(:new).and_return(mock_mapfilter(:category => 'shopping'))
  		mock_mapfilter.should_receive(:query=).with('dress')
  		mock_mapfilter.should_receive(:location=).with('berkeley')

  		#soft filter settings
  		mock_mapfilter.should_receive(:num_ratings_weight=).with(nil)
  		mock_mapfilter.should_receive(:avg_rating_weight=).with(nil)
  		mock_mapfilter.should_receive(:cheapness_weight=).with(nil)
  				
  		mock_mapfilter.should_receive(:add_nodes=).with("")
  		mock_mapfilter.should_receive(:exclude_nodes=).with("")
  		MapFilter.stub(:getCategory).and_return('shopping')
  		mock_mapfilter.should_receive(:category=).with('shopping')
  		#check if category is restaurants, events, shopping, or nightlife
  		mock_mapfilter.should_receive(:category)
  		#call yelp delegate because the category is shopping
		YelpDelegate.should_receive(:search_by_filter).with(mock_mapfilter).and_return(mock_business_list)
#call gmap delegate because the business list exists
GmapDelegate.should_receive(:getGMap).with(mock_business_list)		
  		get :search, :query => 'dress', :location => 'berkeley'
  	end
  	
  	it "searches for nightlife using Yelp Delegate" do
  		#create a new mapfilter
  		MapFilter.should_receive(:new).and_return(mock_mapfilter(:category => 'nightlife'))
  		mock_mapfilter.should_receive(:query=).with('bars')
  		mock_mapfilter.should_receive(:location=).with('berkeley')

  		#soft filter settings
  		mock_mapfilter.should_receive(:num_ratings_weight=).with(nil)
  		mock_mapfilter.should_receive(:avg_rating_weight=).with(nil)
  		mock_mapfilter.should_receive(:cheapness_weight=).with(nil)
  		 		
  		mock_mapfilter.should_receive(:add_nodes=).with("")
  		mock_mapfilter.should_receive(:exclude_nodes=).with("")
  		MapFilter.stub(:getCategory).and_return('nightlife')
  		mock_mapfilter.should_receive(:category=).with('nightlife')
  		#check if category is restaurants, events, shopping, or nightlife
  		mock_mapfilter.should_receive(:category)
  		#call yelp delegate because the category is shopping
		YelpDelegate.should_receive(:search_by_filter).with(mock_mapfilter).and_return(mock_business_list)
#call gmap delegate because the business list exists
GmapDelegate.should_receive(:getGMap).with(mock_business_list)		
  		get :search, :query => 'bars', :location => 'berkeley'
  	end  	    		
  end

 describe "save" do
  	it "saves the map" do
  		#create a new map
  		Map.should_receive(:new).and_return(mock_map)
  		mock_map.should_receive(:user_id=).with('1')		
  		mock_map.should_receive(:title=).with('my map')
  		mock_map.should_receive(:permission=).with('1')
  		#create a new mapfilter
  		MapFilter.should_receive(:new).and_return(mock_mapfilter(:category => 'restaurants'))
  		mock_mapfilter.should_receive(:query=).with('pizza')  		
  		mock_mapfilter.should_receive(:location=).with('berkeley')
  		mock_mapfilter.should_receive(:category=).with('restaurants')		
  		mock_mapfilter.should_receive(:add_nodes=).with("")
  		mock_mapfilter.should_receive(:exclude_nodes=).with("") 
  		mock_mapfilter.should_receive(:num_ratings_weight=).with([:map_num_ratings_weight]) 		
  		mock_mapfilter.should_receive(:avg_rating_weight=).with([:map_avg_rating_weight]) 	
  		mock_mapfilter.should_receive(:cheapness_weight=).with([:map_cheapness_weight]) 	
  		#map model saves the data
  		mock_map.should_receive(:save)
  		mock_mapfilter.should_receive(:map_id=).with(mock_map.id)
  		#mapfilter saves the data
  		mock_mapfilter.should_receive(:save)		  		
  		get :save, :id => "1", :map_user_id => "1", :map_title => "my map", :map_permission => "1", :map_query => "pizza", :map_location => "berkeley", :map_category => "restaurants", :map_add => "", :map_exclude => ""  		
  	end  
  end
  
   describe "save favorite" do
  	it "favorites the map" do
  		#create a new favorite map
  		FavoriteMap.should_receive(:new).and_return(mock_favoritemap)
  		#fill in data for favoritemap
  		mock_favoritemap.should_receive(:user_id=).with('1')		
  		mock_favoritemap.should_receive(:map_id=).with('1')
  		#favoritemap saves the data
  		mock_favoritemap.should_receive(:save)  		
  		get :save_favorite, :user_id => "1", :map_id => "1"
  	end  
  end
  
   describe "add" do
  	it "adds a new venue to the map with the first use of add_node" do
  		#return a map
  		Map.should_receive(:find).and_return(mock_map)
  		#map has mapfilter with add_nodes initially empty
		mock_map.should_receive(:map_filter).and_return(mock_mapfilter(:add_nodes => ''))
  		#because there are initially no add_nodes set mapfilter.add_nodes to the input  		
  		mock_mapfilter.should_receive(:add_nodes=).with('yogurt')		
  		#mapfilter saves the data
  		mock_mapfilter.should_receive(:save)
  		get :add, :map_id => "1", :add => 'yogurt'
  	end

  	it "adds a new venue to the map with more than 1 use of add_node" do
  		#return a map
  		Map.should_receive(:find).and_return(mock_map)
  		#map has mapfilter with add_nodes initially empty
		mock_map.should_receive(:map_filter).and_return(mock_mapfilter(:add_nodes => 'pizza'))
  		#because there is something in add_nodes append the input to mapfilter.add_nodes
  		mock_mapfilter.should_receive(:add_nodes=).with('pizza, yogurt')		
  		#mapfilter saves the data
  		mock_mapfilter.should_receive(:save)
  		get :add, :map_id => "1", :add => 'yogurt'
  	end  	
  end  
  
end