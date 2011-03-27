class CheapgamedealsDelegate < ActiveRecord::Base
	require 'rubygems'
	require 'hpricot'
	require 'open-uri'
	require 'uri'
	require 'net/http'
	require 'date'
	require 'twitter'

	
	cattr_accessor :result_array

# reopen the class
String.class_eval do
# define new method
  def to_my_utf8
    ::Iconv.conv('UTF-8//IGNORE', 'UTF-8', self + ' ')[0..-2]
  end
end

def self.get_breaking_news
	
	breaking_news = Twitter.user_timeline("New_Game_Deals").map do |item|
	#item = Twitter.user_timeline("New_Game_Deals")[2]
	  temp_deal = Deal.new
	  #Mega Man Zero Collection (Nintendo DS) $20.17 [MSRP = $30] http://amzn.to/eRZ2Kr
	  dealtext = item.text
	  partial_name = get_title(dealtext)  
	  temp_deal.buy_link = get_buy_link(dealtext)
	  temp_deal.guid = item.id
	  temp_deal.cost = get_price(dealtext)  
	  temp_deal.cost_retail = get_price_retail(dealtext)

	  #add cost and Amazon to name
	  unless temp_deal.cost.nil?
	  temp_deal.name = partial_name + ' $' + sprintf("%.2f", temp_deal.cost) + ' shipped at Amazon'
	  temp_deal.name = temp_deal.name.to_my_utf8
  	  end
	  
	  #write description
	  unless partial_name.nil? || temp_deal.cost.nil? || temp_deal.buy_link.nil?
	  temp_deal.description = "Amazon has the " + partial_name + "for $" + sprintf("%.2f", temp_deal.cost) + ". <a href=" + temp_deal.buy_link + "><b>AMAZON</b></a>"
	  temp_deal.description = temp_deal.description.to_my_utf8 
  	  end
	  
	  unless temp_deal.cost_retail.nil? || temp_deal.cost.nil?
	  	#Lower profit margin to make a more conservative estimate
	  	#PROFIT MARGIN = 0.375 * (RETAIL PRICE - BUY PRICE) - SHIPPING
	  	temp_deal.profit_margin = 0.375 * (temp_deal.cost_retail - temp_deal.cost) - DealAdapter.get_shipping_cost(temp_deal.name)
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
  	  
	  temp_deal.source = "cheapgamedeals"
	  temp_deal.category = "videogame"
	  temp_deal.publish_date = DateTime.parse(item.created_at)

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

def self.get_title(dealtext)
	#Mega Man Zero Collection (Nintendo DS) $20.17 [MSRP = $30] http://amzn.to/eRZ2Kr
	title = /(^[^\$]+)\$/.match(dealtext)
	unless title.nil?
	title_value = title[1]
	end
end

def self.get_price(dealtext)
	#Mega Man Zero Collection (Nintendo DS) $20.17 [MSRP = $30] http://amzn.to/eRZ2Kr
	price = /\$(\d+\.\d+) \[MSRP/.match(dealtext)
	#Mega Man Zero Collection (Nintendo DS) $20 [MSRP = $30] http://amzn.to/eRZ2Kr
	if price.nil?
    price = /\$(\d+) \[MSRP/.match(dealtext)		
	end	
	#Remove possible commas in price
	unless price.nil?
	price_value = price[1].tr(',', '').to_f
	end
	return price_value
end

def self.get_price_retail(dealtext)
	#Mega Man Zero Collection (Nintendo DS) $20.17 [MSRP = $30.17] http://amzn.to/eRZ2Kr
	price = /\[MSRP = \$(\d+\.\d+)/.match(dealtext)
	#Mega Man Zero Collection (Nintendo DS) $20.17 [MSRP = $30] http://amzn.to/eRZ2Kr
	if price.nil?
    price = /\[MSRP = \$(\d+)/.match(dealtext)		
	end	
	#Remove possible commas in price
	unless price.nil?
	price_value = price[1].tr(',', '').to_f
	end
	return price_value
end

def self.get_buy_link(dealtext)
	if contains_price_comparison(dealtext)
		buy_link = /(http:\/\/[^"]*)$/.match(dealtext)
		unless buy_link.nil?
			cheap_buy_link = buy_link[1]
			amazon_html_temp = fetch(cheap_buy_link)
			#404 Not found
			if amazon_html_temp == "cannot find page"
				amazon_html = "cannot find page"
			else
			amazon_html = amazon_html_temp.body
			end
			#<input type="hidden" name="origURL" value="http://www.amazon.com/gp/product/B001TOQ8WU?ie=UTF8&amp;redirect=true&amp;tag=greendcom-20&amp;linkCode=as2&amp;camp=1789&amp;creative=390957&amp;creativeASIN=B001TOQ8WU" />
			expression_for_buy_link = /<input type="hidden" name="origURL" value="(http:\/\/[^"]*)/
			buy_link_result = expression_for_buy_link.match(amazon_html)
			
			unless  buy_link_result.nil?
				actual_buy_link = buy_link_result[1]
				affiliate_link = change_affiliate(actual_buy_link)			
			end	
		end
	end
	affiliate_link
end

def self.change_affiliate(actual_buy_link)	
	#http://www.amazon.com/gp/product/B001TOQ8WU?ie=UTF8&redirect=true&tag=greendcom-20&linkCode=as2&camp=1789&creative=390957&creativeASIN=B001TOQ8WU
	#http://www.amazon.com/gp/product/B001TOQ8WU?ie=UTF8&tag=stashflip-20&linkCode=as2&camp=1789&creative=390957&creativeASIN=B001TOQ8WU
	#Replace affiliate id
	temp_link = actual_buy_link.gsub(/greendcom/, "stashflip")
	#Remove &redirect=true
	affiliate_link = temp_link.gsub(/&amp;redirect=true/, "")
end

def self.contains_price_comparison(dealtext)
	dealtext =~ /MSRP =/
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
