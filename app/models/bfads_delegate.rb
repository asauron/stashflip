class BfadsDelegate < ActiveRecord::Base
	require 'rubygems'
	require 'hpricot'
	require 'open-uri'
	require 'uri'
	require 'net/http'
	require 'date'

	
	cattr_accessor :result_array

def self.get_breaking_news(min)
	doc = Hpricot.XML(open("http://bfads.net/Hot-Deals-RSS"))
	
	cutoff_time = Time.now - 60 * min
	
	breaking_news = (doc/"item").map do |item|
	  temp_deal = Deal.new
	  temp_deal.name = (item/"title").inner_html
	  temp_deal.description = (item/"description").inner_text
	  temp_deal.buy_link = get_buy_link(temp_deal.description) 
	  temp_deal.guid = (item/"guid").inner_html
	  temp_deal.cost = get_price(temp_deal.name)  
	  temp_deal.cost_retail = get_price_retail(temp_deal.description)
  	  
	  unless temp_deal.cost_retail.nil? || temp_deal.cost.nil?
	  	#Lower profit margin to make a more conservative estimate
	  	#PROFIT MARGIN = 0.4 * (RETAIL PRICE - BUY PRICE) - SHIPPING
	  	temp_deal.profit_margin = 0.4 * (temp_deal.cost_retail - temp_deal.cost) - DealAdapter.get_shipping_cost(temp_deal.name)
  	  end
	  
  	  #Reset retail cost and profit margin to 0	if there is no retail cost listed    	  
  	  if temp_deal.cost_retail.nil? 
  	  	temp_deal.cost_retail=0
  	  	temp_deal.profit_margin=0
  	  end
  	  
  	  #Reset profit margin to 0 if you cannot resell it
      if temp_deal.profit_margin < 0
      	temp_deal.profit_margin = 0	  
  	  end
  	  
	  temp_deal.source = "bfads"
	  temp_deal.publish_date = DateTime.parse((item/"pubDate").inner_html)

	  #Stash if you make less than $7 on reselling. Flip if you make more than $7 on reselling.
	  if temp_deal.profit_margin < 7
	  temp_deal.stashflip_status = "stash"
	  elsif temp_deal.profit_margin >= 7
	  temp_deal.stashflip_status = "flip"
      end
  	  
	  temp_deal.permadeal = "no"
	  temp_deal
	end
end

def self.get_price(name)
	price = /\$(\d+\.\d+)/.match(name)
	if price.nil?
	price = /\$(\d+)/.match(name)
	end	
	unless price.nil?
	price_value = price[1].to_f
	end
	return price_value
end

def self.get_price_retail(description)
	#Next lowest price on PriceGrabber is $29.22 shipped.
	price_retail = /is \$(\d+\.\d+)/.match(description)
	#Comparatively, Microsoft Store sells it for $129.99. 
	if price_retail.nil?
	price_retail = /for \$(\d+\.\d+)\./.match(description)
	end
	
	
	unless price_retail.nil?
		price_retail_value = price_retail[1].to_f
	end
		
	return price_retail_value 
end

def self.get_buy_link(description)
	buy_link = /a href=\s*"([^"]*)/.match(description)
	buy_link[1]
end

def self.contains_price_comparison(description)
	description =~ /Next lowest price on/ || /Comparatively/
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
