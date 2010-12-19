require 'spec_helper'
	
describe EventfulDelegate do
  before(:each) do
  end
  
  def mock_map(stubs={})
    @mock_map ||= mock_model(Map, stubs)
  end
  
  def mock_mapfilter(stubs={})
    @mock_mapfilter ||= mock_model(MapFilter, stubs)
  end
  
  it "should substitute spaces with + for generating search params" do
  	params = EventfulDelegate.generate_search_params(mock_mapfilter(:query => 'golden state warriors', :location=>'oakland, ca'))
  	params[:keywords].should == 'golden+state+warriors'
  	params[:location].should == 'oakland,+ca'
  	params[:page_size].should == 15	  	
  end

  it "should limit the number of results from Eventful to 15" do
  	params = EventfulDelegate.generate_search_params(mock_mapfilter(:query => 'golden state warriors', :location=>'oakland, ca'))
  	params[:page_size].should == 15	  	
  end
    
  it "should perform a search using the eventful API" do
  	result = EventfulDelegate.search_by_filter(mock_mapfilter(:query => 'tour', :location=>'oakland'))
  	result.should_not be_nil  	
  end  
  
  it "should perform a search using the eventful API and return nil if there are no results" do
  	result = EventfulDelegate.search_by_filter(mock_mapfilter(:query => '20698436436', :location=>'20698436436'))
  	result.should be_nil  	
  end
  
end