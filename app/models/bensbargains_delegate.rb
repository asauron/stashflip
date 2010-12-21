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
	  temp_deal.cost_retail = get_price_retail(temp_deal.description)
	  unless temp_deal.cost_retail.nil? || temp_deal.cost.nil?
	  	temp_deal.profit_margin = temp_deal.cost_retail - temp_deal.cost
  	  end
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

def self.get_price_retail(description)
	expression_for_link = /href=\"([^\"]*)\"[^>]*>Compare<\/a>/
	comparison_link_info = expression_for_link.match(description)
	if comparison_link_info.nil?
		return 0
	else
	comparison_link = comparison_link_info[1]
	
	#raise ArgumentError, comparison_link if 1 == 1
	
	comparison_html = fetch(comparison_link).body	
	
if comparison_html =~ /Sorry/
		return 0
else
	#comparison_html = fetch("http://bensbargains.net/link.php?threadid=172265&linkid=0").body
	#comparison_html = fetch("http://bensbargains.nextag.com/8GB-SDHC-Class-4/zzbensbargainszB1z0--search-html").body
	#comparison_html = fetch("http://bensbargains.nextag.com/MSI-Microstar-GT660-R004US/zzbensbargainszB1z0--search-html").body

	expression_for_lowest_price = /\$([0-9,]+\.[0-9]{2}?)/
	extracted_prices = expression_for_lowest_price.match(comparison_html)

	
	if extracted_prices.nil?
	expression_for_lowest_price = /\$([0-9,]+)/
	extracted_prices = expression_for_lowest_price.match(comparison_html)
	end
	
	#change 1,400.00 to 1400.00
	price_retail_string = (extracted_prices[1]).gsub(/,/, '')
	price_retail_value = price_retail_string.to_f

	return price_retail_value	
end
end
end

def self.contains_price_comparison(description)
	description =~ /Compare/
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
