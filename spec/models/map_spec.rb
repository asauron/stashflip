require 'spec_helper'

describe Map do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :title => "value for title"
    }
    
    Map.create!(:id => 1, :user_id => 1, :title => "map1", :rating_average => "1")	
  	Map.create!(:id => 2, :user_id => 2, :title => "map2", :rating_average => "2")	
  	Map.create!(:id => 3, :user_id => 3, :title => "map3", :rating_average => "3")	
  	Map.create!(:id => 4, :user_id => 4, :title => "map4", :rating_average => "4")	
  	Map.create!(:id => 5, :user_id => 5, :title => "map5", :rating_average => "5")
  	Map.create!(:id => 6, :user_id => 5, :title => "map6", :rating_average => "1")  	
  		    
  	@map1 = Map.find_by_id(1)
  	@map2 = Map.find_by_id(2)
  	@map3 = Map.find_by_id(3)
  	@map4 = Map.find_by_id(4)
  	@map5 = Map.find_by_id(5)
  	@map6 = Map.find_by_id(6)  	
  	
  	MapFilter.create!(:map_id => 1, :query => "pizza", :location => "berkeley", :category => "restaurants")
  	MapFilter.create!(:map_id => 2, :query => "pizza", :location => "berkeley", :category => "restaurants")
  	MapFilter.create!(:map_id => 3, :query => "concert", :location => "berkeley", :category => "events")
  	MapFilter.create!(:map_id => 4, :query => "concert", :location => "berkeley", :category => "events")
  	MapFilter.create!(:map_id => 5, :query => "northface", :location => "berkeley", :category => "shopping")
  	MapFilter.create!(:map_id => 6, :query => "bars", :location => "berkeley", :category => "nightlife")  	
  	
   	@mapfilter1 = MapFilter.find_by_map_id(1)
  	@mapfilter2 = MapFilter.find_by_map_id(2)
  	@mapfilter3 = MapFilter.find_by_map_id(3)
  	@mapfilter4 = MapFilter.find_by_map_id(4)
  	@mapfilter5 = MapFilter.find_by_map_id(5)
  	@mapfilter6 = MapFilter.find_by_map_id(6) 	  	 	
  end

  def mock_map(stubs={})
    @mock_map ||= mock_model(Map, stubs)
  end
  
  def mock_mapfilter(stubs={})
    @mock_mapfilter ||= mock_model(MapFilter, stubs)
  end
    
  it "should create a new instance given valid attributes" do
    Map.create!(@valid_attributes)
  end
  
  it "should return top rated maps" do
  	top_rated = Map.top_rated_maps
  	top_rated[0].should == @map5
  	top_rated[1].should == @map4
  	top_rated[2].should == @map3
  	top_rated[3].should == @map2
  	top_rated[4].should == @map1
  end
  
  it "should return top maps in restaurants" do
  	top_categories = Map.top_category_maps("restaurants")
  	top_categories[0].should == @map2
  	top_categories[1].should == @map1
  end
  
  it "should return top maps in events" do
  	top_categories = Map.top_category_maps("events")
  	top_categories[0].should == @map4
  	top_categories[1].should == @map3
  end
  
  it "should return 1 random map from each of your friends" do
    User.create!(:username => "zappos1", :id => 1, :email => "zappos1@uci.edu", :password => "letmein", :password_confirmation => "letmein")	
  	User.create!(:username => "zappos2", :id => 2, :email => "zappos2@ucsd.edu", :password => "letmein", :password_confirmation => "letmein")
  	User.create!(:username => "zappos5", :id => 5, :email => "zappos5@ucsd.edu", :password => "letmein", :password_confirmation => "letmein")  	
  	@user1 = User.find_by_username("zappos1")
  	@user2 = User.find_by_username("zappos2")  	
  	@user5 = User.find_by_username("zappos5")
  	
  	Friendship.request(@user1, @user2)
	Friendship.accept_friend(@user1, @user2)

  	Friendship.request(@user1, @user5)
	Friendship.accept_friend(@user1, @user5)
	
	Friendship.request(@user2, @user5)
	Friendship.accept_friend(@user2, @user5)
		
	top_friends = Map.top_friends_maps(@user5)
	top_friends[0].should == @map1	
	top_friends[1].should == @map2
  end  
    
end
