class DealnewshdtvDelegate < ActiveRecord::Base
	require 'rubygems'
	require 'hpricot'
	require 'open-uri'
	require 'uri'
	require 'net/http'
	require 'date'

	
	cattr_accessor :result_array

def self.get_breaking_news(min)
	doc = Hpricot.XML(open("http://dealnews.com/rss/159"))
	
	cutoff_time = Time.now - 60 * min
	
	breaking_news = (doc/"item").map do |item|
	  temp_deal = Deal.new
	  temp_deal.name = (item/"title").inner_html
	  temp_deal.description = (item/"description").inner_text
	  temp_deal.buy_link = get_buy_link( (item/"link").inner_html )
	  temp_deal.guid = (item/"guid").inner_html
	  temp_deal.cost = get_price(temp_deal.name)  
	  temp_deal.cost_retail = get_price_retail(temp_deal.cost, temp_deal.description)
  	  
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
  	  
	  temp_deal.source = "dealnewshdtv"
	  temp_deal.category = "hdtv"
	  temp_deal.publish_date = DateTime.parse((item/"pubDate").inner_html)

	  #Stash if you make less than $7 on reselling. Flip if you make more than $7 on reselling.
	  if temp_deal.profit_margin < 100
	  temp_deal.stashflip_status = "stash"
	  elsif temp_deal.profit_margin >= 100
	  temp_deal.stashflip_status = "flip"
      end
  	  
	  temp_deal.permadeal = "no"
	  temp_deal
	end
end

def self.get_price(name)
	#Sharp AQUOS 55" 120Hz 1080p LED LCD HDTV for $100.00 + free shipping
	price = /\$(\d+\.\d+)/.match(name)
	#Sharp AQUOS 55" 120Hz 1080p LED LCD HDTV for $1,190 + free shipping
	if price.nil?
	price = /\$(\d+,\d+)/.match(name)
	end
	#Sharp AQUOS 55" 120Hz 1080p LED LCD HDTV for $100 + free shipping
	if price.nil?
	price = /\$(\d+)/.match(name)
	end		
	#Remove possible commas in price
	unless price.nil?
	price_value = price[1].tr(',', '').to_f
	end
	return price_value
end

def self.get_price_retail(price_sale, description)
	#With $5 for shipping, that's $136 under last month's mention (which had a smaller hard drive) and the lowest total price we could find by $126.
	price_retail = /by \$(\d+)/.match(description)
	#With free shipping, that's the lowest total price we've seen for either version by at least $10.
	if price_retail.nil?
	price_retail = /by at least \$(\d+)/.match(description)	
	end
	unless price_retail.nil?
		price_retail_value = price_retail[1].to_f
	end
	
	if price_retail_value.nil?
	return 0
	else
	return price_retail_value + price_sale
	end

end

def self.get_buy_link(rss_link)
	dealnews_html = fetch(rss_link).body
	expression_for_buy_link = /<a class="bgbn" href="([^"]+)" target="_blank"><em class="l"><\/em><em class="c">Shop Now!/
	buy_link = expression_for_buy_link.match(dealnews_html)[1]
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
