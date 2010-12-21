class PasswirdDelegate < ActiveRecord::Base
	require 'rubygems'
	require 'hpricot'
	require 'open-uri'
	require "yelp"
	require 'net/http'
	require 'uri'

	
	cattr_accessor :result_array

def self.get_breaking_news(min)
	doc = open("http://passwird.com/n/rss.xml") { |f| Hpricot(f) }
	
	cutoff_time = Time.now - 60 * min
	
	breaking_news_array = []
	
	breaking_news = (doc/"item").map do |item|
	  temp_deal = Deal.new
	  temp_deal.name = (item/"title").inner_html
	  temp_deal.description = (item/"description").inner_text
	  temp_deal.guid = (item/"guid").inner_html
	  temp_deal.cost = get_price(temp_deal.name)
	  temp_deal.source = "passwird"
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
	description =~ /Next lowest price on/
end    

def self.fetch(uri_str, limit = 10)
      # You should choose better exception.
      raise ArgumentError, 'HTTP redirect too deep' if limit == 0

      #response = Net::HTTP.get_response(URI.parse(uri_str))
      response = Net::HTTP.get_response(URI.parse(URI.encode(uri_str)))
      
      case response
      when Net::HTTPSuccess     then response
      when Net::HTTPRedirection then fetch(response['location'], limit - 1)
      else
        response.error!
      end
end
  
end
