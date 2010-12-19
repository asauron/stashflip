class YelpDelegate < ActiveRecord::Base
	require 'rubygems'
	require 'hpricot'
	require 'open-uri'
	require "yelp"
	
	cattr_accessor :result_array
	
	@ywsid = "sEhkNKs8pcwqCtOPVu97lg"
	#@ywsid = "jBMtTnQ3Kbl0y0vKhEZ6bA"
	#@ywsid = "kgDaWispEXAg94HFvy-a9w"
	
	#@search_type = type
	@return_limit = 25
  @results_array = nil
 
  def self.generate_search_params(mapfilter,numberToReturn) #takes in filter
    params = {
      :term => mapfilter.query,
      :zipcode => mapfilter.location,
      :radius => 5,
      :business_count => numberToReturn,
      :yws_id => @ywsid,
    }
    #in default case the category string is nothing.. ''
    #the default behavior is that we don't set 
    #any specific category to search in
    if mapfilter.category != ''
      categs = mapfilter.category.split('+')
      params[:category] = categs
    end
    return params
  end
  
  #returns array of businesses to add
  def self.add_nodes(mapfilter)
    #first parse string, and extract yelp ids, separated by commas into an array
    add_ids = mapfilter.add_nodes.split(/, /)
    result_array = []
    request = generate_search_params(mapfilter,1)
    add_ids.each do |yelp_query|
      #in here make request to yelp and add to businesses
      request[:term] = yelp_query
      temp = get_yelp_results(request) 
      result_array = result_array + temp["businesses"]
    end
    result_array = result_array.uniq
    return result_array
  end
  
  #takes in an array of businesses and yelp ids, goes through the array and removes businesses
  def self.exclude_nodes(business_array,mapfilter)
    exclude_ids = mapfilter.exclude_nodes.split(/, /)
    result_array = []
    request = generate_search_params(mapfilter,1)
    exclude_ids.each do |exclude_id|
        #in here make request to yelp and add to businesses
        request[:term] = exclude_id
        temp = get_yelp_results(request) 
        result_array = result_array + temp["businesses"]
    end
    result_array = result_array.uniq
    business_array = business_array - result_array
    return business_array
  end
    
  def self.get_yelp_results(params)
    client = Yelp::Client.new
    request = Yelp::Review::Request::Location.new(params)
    result_array = client.search(request)
  end
  
  def self.get_beatmap_rating(business, mapfilter)
  	num_ratings_weight = mapfilter.num_ratings_weight
  	num_ratings_score = get_num_ratings_score(business)
  	avg_rating_weight = mapfilter.avg_rating_weight
  	avg_rating_score = business["avg_rating"]
  	cheapness_weight = mapfilter.cheapness_weight
  	cheapness_score = 5
  	total = (num_ratings_weight*num_ratings_score) + (avg_rating_weight*avg_rating_score) + (cheapness_weight*cheapness_score)
  	out_of = (num_ratings_weight*5) + (avg_rating_weight*5) + (cheapness_weight*5)
  	result = (total/out_of)*15
  	result.to_int
  end
	
	def self.get_num_ratings_score(business)
		num_ratings = business["review_count"]
		if num_ratings > 1500
			num_ratings_score = 5
		elsif num_ratings <= 1500 && num_ratings > 1000
			num_ratings_score = 4
		elsif num_ratings <= 1000 && num_ratings > 500
			num_ratings_score = 3
		elsif num_ratings <= 500 && num_ratings > 200
			num_ratings_score = 2
		else
			num_ratings_score = 1
		end
		num_ratings_score
	end
	
	def self.get_cheapness_score(business)
	end
	
  #results_array is an array of businesses returned by the Yelp API, with each element being a hash table with fields such as "address1", "longitude", etc.
  def self.search_by_filter(mapfilter)
		request = generate_search_params(mapfilter,@return_limit)
		result_array = get_yelp_results(request) 
		result_array = result_array["businesses"]
		result_array += add_nodes(mapfilter)
		result_array = exclude_nodes(result_array, mapfilter)
		result_array.each do |business|
			business["beatmap_rating"] = get_beatmap_rating(business, mapfilter)
		end		
  result_array = result_array.sort_by {|business| -1*business["beatmap_rating"].to_i }
		
  end
  

  
end
