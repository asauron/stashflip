require 'spec_helper'

describe MapFilter do
  before(:each) do
    @valid_attributes = {
      
    }
    
    @params_restaurants = {
    	:restaurants => "on",
    	:events => nil,
    	:shopping => nil,
    	:nightlife => nil
	}

    @params_events = {
     	:restaurants => nil,
    	:events => "on",
    	:shopping => nil,
    	:nightlife => nil
	}	
	
    @params_shopping = {
     	:restaurants => nil,
    	:events => nil,
    	:shopping => "on",
    	:nightlife => nil
	}	
	
    @params_nightlife = {
     	:restaurants => nil,
    	:events => nil,
    	:shopping => nil,
    	:nightlife => "on"
	}
	
	@params_restaurants_events = {
     	:restaurants => "on",
    	:events => "on",
    	:shopping => nil,
    	:nightlife => nil
	}
	
	@params_restaurants_events_shopping = {
     	:restaurants => "on",
    	:events => "on",
    	:shopping => "on",
    	:nightlife => nil
	}
	
	@params_restaurants_events_shopping_nightlife = {
     	:restaurants => "on",
    	:events => "on",
    	:shopping => "on",
    	:nightlife => "on"
	}					
	    
  end

  it "should create a new instance given valid attributes" do
    MapFilter.create!(@valid_attributes)
  end
  
  it "should append restaurants if params has restaurants" do
  	category = MapFilter.getCategory(@params_restaurants)
  	category.should == "restaurants"
  end

  it "should append events if params has events" do
  	category = MapFilter.getCategory(@params_events)
  	category.should == "events"
  end
  
  it "should append shopping if params has shopping" do
  	category = MapFilter.getCategory(@params_shopping)
  	category.should == "shopping"
  end
  
  it "should append nightlife if params has nightlife" do
  	category = MapFilter.getCategory(@params_nightlife)
  	category.should == "nightlife"
  end
  
  it "should append restaurants and events if params has restaurants and events" do
  	category = MapFilter.getCategory(@params_restaurants_events)
  	category.should == "restaurants+events"
  end
  
  it "should append restaurants, events, and shopping if params has restaurants, events, and shopping" do
  	category = MapFilter.getCategory(@params_restaurants_events_shopping)
  	category.should == "restaurants+events+shopping"
  end
  
  it "should append restaurants, events, shopping, and nightlife if params has restaurants, events, shopping, and nightlife" do
  	category = MapFilter.getCategory(@params_restaurants_events_shopping_nightlife)
  	category.should == "restaurants+events+shopping+nightlife"
  end  
  
end
