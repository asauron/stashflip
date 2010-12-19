require 'spec_helper'

describe YelpDelegate do
  before(:each) do
  end
  
  def mock_mapfilter(stubs={})
    @mock_mapfilter ||= mock_model(MapFilter, stubs)
  end
  
  #generate search params
  describe "generate search params" do

    it "should generate params that match the mapfilter" do
      params = YelpDelegate.generate_search_params(mock_mapfilter(:query => 'donuts', :location=>'berkeley', :category => 'restaurants', :num_ratings_weight => 1, :avg_rating_weight => 1, :cheapness_weight => 1),5)
      params[:term].should == 'donuts'
      params[:zipcode].should == 'berkeley'
      params[:category].should == ['restaurants']
    end
    
    it "should split categories into an array" do
      params = YelpDelegate.generate_search_params(mock_mapfilter(:query => 'donuts', :location=>'berkeley', :category => 'restaurants+shops+nightlife', :num_ratings_weight => 1, :avg_rating_weight => 1, :cheapness_weight => 1),5)
      params[:term].should == 'donuts'
      params[:zipcode].should == 'berkeley'
      params[:category].should == ['restaurants','shops', 'nightlife']
    end
    
    it "should allow categories to be nil" do
      params = YelpDelegate.generate_search_params(mock_mapfilter(:query => 'donuts', :location=>'berkeley', :category => '', :num_ratings_weight => 1, :avg_rating_weight => 1, :cheapness_weight => 1),5)
      params[:term].should == 'donuts'
      params[:zipcode].should == 'berkeley'
      params[:category].should == nil
    end

  end

  #add nodes
  #need to mock out what yelp returns
  describe "add nodes" do
    before(:each) do
      YelpDelegate.stub(:get_yelp_results) do |arg|
        {"businesses" => [arg[:term]]}
      end
    end
    
    describe "empty add field" do
      it "should return empty array" do
        result_array = YelpDelegate.add_nodes(mock_mapfilter(:query => 'donuts', :location=>'berkeley', :category => 'restaurants', :add_nodes => '', :num_ratings_weight => 1, :avg_rating_weight => 1, :cheapness_weight => 1))
        result_array.should == []
      end
    end
    
    describe "add field with 1 entry" do
      it "should add 1 store" do
        result_array = YelpDelegate.add_nodes(mock_mapfilter(:query => 'donuts', :location=>'berkeley', :category => 'restaurants', :add_nodes => 'yogurtland', :num_ratings_weight => 1, :avg_rating_weight => 1, :cheapness_weight => 1))
        result_array.length.should == 1
      end
    end
    
    describe "add field with 2 entries" do
      it "should add 2 stores" do
        result_array = YelpDelegate.add_nodes(mock_mapfilter(:query => 'donuts', :location=>'berkeley', :category => 'restaurants', :add_nodes => 'yogurtland, tacobell', :num_ratings_weight => 1, :avg_rating_weight => 1, :cheapness_weight => 1))
        result_array.length.should == 2
      end
    end
    
    describe "add field with 5 entries" do
      it "should add 5 stores" do
        result_array = YelpDelegate.add_nodes(mock_mapfilter(:query => 'donuts', :location=>'berkeley', :category => 'restaurants', :add_nodes => 'yogurtland, tacobell, pizza, hotdog, candy', :num_ratings_weight => 1, :avg_rating_weight => 1, :cheapness_weight => 1))
        result_array.length.should == 5
      end
    end
    
    describe "add field with duplicate entries" do
      it "should add it once" do
        result_array = YelpDelegate.add_nodes(mock_mapfilter(:query => 'donuts', :location=>'berkeley', :category => 'restaurants', :add_nodes => 'yogurtland, yogurtland'))
        result_array.length.should == 1
      end
    end
    
  end
  
  #exclude nodes
  #mock out what yelp returns
  describe "exclude nodes" do
    before(:each) do
      YelpDelegate.stub(:get_yelp_results) do |arg|
        {"businesses" => [arg[:term]]}
      end
    end
    
    describe "remove field with no entry" do
      it "should remove 0 store" do
        result_array = YelpDelegate.exclude_nodes(['business'],mock_mapfilter(:query => 'donuts', :location=>'berkeley', :category => 'restaurants', :add_nodes => 'yogurtland',:exclude_nodes => '', :num_ratings_weight => 1, :avg_rating_weight => 1, :cheapness_weight => 1))
        result_array.length.should == 1
      end
    end
    
    describe "remove field with 1 entry" do
      it "should remove 1 store" do
        result_array = YelpDelegate.exclude_nodes(['business'],mock_mapfilter(:query => 'donuts', :location=>'berkeley', :category => 'restaurants', :add_nodes => 'yogurtland',:exclude_nodes => 'business', :num_ratings_weight => 1, :avg_rating_weight => 1, :cheapness_weight => 1))
        result_array.length.should == 0
      end
    end
    
    describe "remove field with duplicate entry" do
      it "should remove 1 store" do
        result_array = YelpDelegate.exclude_nodes(['business','stays'],mock_mapfilter(:query => 'donuts', :location=>'berkeley', :category => 'restaurants', :add_nodes => 'yogurtland',:exclude_nodes => 'business, business', :num_ratings_weight => 1, :avg_rating_weight => 1, :cheapness_weight => 1))
        result_array.length.should == 1
      end
    end
    
    describe "remove field with 2 entry" do
      it "should remove 2 store" do
        result_array = YelpDelegate.exclude_nodes(['1a','2a','3a','4a','5a'],mock_mapfilter(:query => 'donuts', :location=>'berkeley', :category => 'restaurants', :add_nodes => 'yogurtland',:exclude_nodes => '1a, 2a', :num_ratings_weight => 1, :avg_rating_weight => 1, :cheapness_weight => 1))
        result_array.length.should == 3
      end
    end
    
    describe "remove field with 5 entry" do
      it "should remove 5 store" do
        result_array = YelpDelegate.exclude_nodes(['1a','2a','3a','4a','5a','6a','7a'],mock_mapfilter(:query => 'donuts', :location=>'berkeley', :category => 'restaurants', :add_nodes => 'yogurtland',:exclude_nodes => '1a, 2a, 3a, 4a, 5a', :num_ratings_weight => 1, :avg_rating_weight => 1, :cheapness_weight => 1))
        result_array.length.should == 2
      end
    end
  end
  
  #search by filter
  describe "search by filter" do
    
    describe "search returns empty" do
      it "should return empty array" do
        YelpDelegate.stub(:get_yelp_results).and_return({"businesses" => []})
        YelpDelegate.stub(:get_beatmap_rating).and_return(1)
        result_array = YelpDelegate.search_by_filter(mock_mapfilter(:query => 'donuts', :location=>'berkeley', :category => 'restaurants+shops+nightlife', :add_nodes => '',:exclude_nodes => '', :num_ratings_weight => 1, :avg_rating_weight => 1, :cheapness_weight => 1))
        result_array.length.should == 0 
      end
    end
    
    describe "removes specific node to return array" do
      it "should return array without specific node" do
        YelpDelegate.stub(:get_yelp_results).and_return({"businesses" => ["business"]})
        YelpDelegate.stub(:exclude_nodes).and_return([])
        YelpDelegate.stub(:get_beatmap_rating).and_return(1)
        result_array = YelpDelegate.search_by_filter(mock_mapfilter(:query => 'donuts', :location=>'berkeley', :category => 'restaurants+shops+nightlife', :add_nodes => 'yogurtland', :exclude_nodes => '', :num_ratings_weight => 1, :avg_rating_weight => 1, :cheapness_weight => 1))
        result_array.include?("add").should == false
      end
    end
    
  end

end