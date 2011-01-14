class BfadsDelegate < ActiveRecord::Base
	require 'rubygems'
	require 'hpricot'
	require 'open-uri'
	require 'uri'
	require 'net/http'
	require 'date'

	
	cattr_accessor :result_array

def self.get_breaking_news(min)
	#doc = Hpricot.XML(open("http://bfads.net/Hot-Deals-RSS"))
	doc = Hpricot.XML(open("http://passwird.com/n/rss.xml"))
	
	cutoff_time = Time.now - 60 * min
	
	breaking_news = (doc/"item").map do |item|
	  temp_deal = Deal.new
	  temp_deal.name = (item/"title").inner_html
	  temp_deal.description = (item/"description").inner_text
	  
	  #check to see if it comes from amazon to replace affiliate link
	  if from_amazon(temp_deal.name)
	  	temp_deal.buy_link = get_amazon_link(temp_deal.description)
	  else
	  	temp_deal.buy_link = get_buy_link(temp_deal.description) 
	  end
  	  
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
	  
	  temp_deal.category = get_category(temp_deal.name)
	  
	  temp_deal.publish_date = DateTime.parse((item/"pubDate").inner_html)

	  temp_deal.stashflip_status = get_stashflip_status(temp_deal.category)
      
	  temp_deal.permadeal = "no"
	  
	  #check to see if it comes from amazon to remove the link from description
	  if from_amazon(temp_deal.name) && !temp_deal.buy_link.nil?
	  	temp_deal.description = remove_amazon_link(temp_deal.description)
	  	temp_deal.description = temp_deal.description + " <a href=\"" + temp_deal.buy_link + "\"><b>AMAZON</b></a>"
	  end
	  
	  temp_deal
	end
end

def self.get_category(name)
	  #if title contains Laptop then tag as laptop
	  if name =~ /Laptop/
	  	category = "laptop"
	  #if title contains HDTV then tag as hdtv	  	
  	  elsif name =~ /HDTV/
  	  	category = "hdtv"
  	  else  	  	
  	  	category = "default"
  	  end
end

def self.get_stashflip_status(category)
	  border_price = case category
  		when "laptop" then 50
  		when "hdtv" then 100
  		else 7
  	  end
	  #Stash if you make less than $7 on reselling. Flip if you make more than $7 on reselling.
	  if temp_deal.profit_margin < border_price
	  	stashflip_status = "stash"
  	  elsif temp_deal.profit_margin >= border_price
	  	stashflip_status = "flip"
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

def self.from_amazon(name)
	name =~ /Amazon/
end

def self.get_amazon_link(description)
	buy_link = /a href=\s*"([^"]*)" target="_blank">AMAZON<\/A>/.match(description)
	unless buy_link.nil?
		uncoded_amazon_link = buy_link[1]
		#http://www.passwird.com/redirect.php?linkID=44716
		amazon_html_temp = fetch(uncoded_amazon_link)
		
		#404 Not found
		if amazon_html_temp == "cannot find page"
			amazon_html = "cannot find page"
		else
		amazon_html = amazon_html_temp.body
		#<!doctype html><head><title>A%2F%2Fwww amazon com%2Fdp%2FB00378KHV4%3Fm%3DATVPDKIKX0DER - Google Search</title>
		expression_for_product_id = /<!doctype html><head><title>A%2F%2Fwww amazon com%2Fdp%2F([^%]*)/
		product_id_result = expression_for_product_id.match(amazon_html)
		unless product_id_result.nil?
			product_id = product_id_result[1]
		end
		expression_for_merchant_id = /<!doctype html><head><title>A%2F%2Fwww amazon com%2Fdp%2F[^%]*%3Fm%3D([^ ]*)/
		merchant_id_result = expression_for_merchant_id.match(amazon_html)
		unless merchant_id_result.nil?
			merchant_id = merchant_id_result[1]
		end
		end
		
		unless product_id.nil? || merchant_id.nil?
		actual_buy_link = 'http://www.amazon.com/gp/product/' + product_id
		end
		
		affiliate_link = change_affiliate(actual_buy_link, product_id)								
	end	
	affiliate_link
	
end

def self.change_affiliate(actual_buy_link, product_id)	
	#Usually redirects to this: http://www.amazon.com/dp/B0038KUYLO?m=ATVPDKIKX0DER
	#But we reconstruct it as: http://www.amazon.com/gp/product/B0038KUYLO
	#Actual affiliate link: http://www.amazon.com/dp/product/B0038KUYLO?ie=UTF8&tag=stashflip-20&linkCode=as2&camp=1789&creative=390957&creativeASIN=B0038KUYLO

	#buy_link + ?ie=UTF8&tag=stashflip-20&linkCode=as2&camp=1789&creative=390957&creativeASIN= + product_id
	#http://www.amazon.com/gp/product/B00378KHV4?ie=UTF8&tag=stashflip-20&linkCode=as2&camp=1789&creative=390957&creativeASIN=B00378KHV4
	unless actual_buy_link.nil? || product_id.nil?
	affiliate_link = actual_buy_link + "?ie=UTF8&tag=stashflip-20&linkCode=as2&camp=1789&creative=390957&creativeASIN=" + product_id	
	end
	affiliate_link
	#raise ArgumentError, affiliate_link if 1 == 1
end

def self.remove_amazon_link(description)
	#delivers fast response time. <b><a href="http://www.passwird.com/redirect.php?linkID=46965" target="_blank">AMAZON</A></B>
	description.gsub(/<a href="(http:[\S]*)" target="_blank">AMAZON<\/A>/, "")
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
        #response.error!
        "cannot find page"
      end
end
  
end
