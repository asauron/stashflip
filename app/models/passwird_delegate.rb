class PasswirdDelegate < ActiveRecord::Base
	require 'rubygems'
	require 'hpricot'
	require 'open-uri'
	require "yelp"
	
	cattr_accessor :result_array

def get_breaking_news(min)
	doc = open("http://passwird.com/n/rss.xml") { |f| Hpricot(f) }
	
	cutoff_time = Time.now - 60 * min
	
	breaking_news = (doc/"item").map do |item|
	  Deal.new((item/"title").inner_html,
	  (item/"description").inner_html,
	  100 )
	end
	
	return breaking_news
end
  
end
