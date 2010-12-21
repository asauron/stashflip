class BensbargainsDelegate < ActiveRecord::Base
	require 'rubygems'
	require 'hpricot'
	require 'open-uri'
	require "yelp"
	require 'net/http'
	require 'uri'

	
	cattr_accessor :result_array

def self.get_breaking_news(min)
	doc = open("http://bensbargains.net/rss.xml/") { |f| Hpricot(f) }
	
	cutoff_time = Time.now - 60 * min
	
	breaking_news_array = []
	
	breaking_news = (doc/"item").map do |item|
	  temp_deal = Deal.new
	  temp_deal.name = (item/"title").inner_html
	  temp_deal.description = (item/"description").inner_text
	  temp_deal.guid = (item/"guid").inner_html
	  temp_deal.cost = get_price(temp_deal.name)
	  temp_deal.source = "bensbargains"
	  breaking_news_array << temp_deal
	end
	
	return breaking_news_array
end

def self.get_price(name)
	cost = /\$(\d+\.\d+)/.match(name)
	if cost.nil?
	cost = /\$(\d+)/.match(name)
	end	
	unless cost.nil?
	cost = cost[1].to_f
	end
	return cost
end

def self.contains_price_comparison(description)
	description =~ /Compare/
end    
  
end
