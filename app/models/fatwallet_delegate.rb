class FatwalletDelegate < ActiveRecord::Base
	require 'rubygems'
	require 'hpricot'
	require 'open-uri'
	require 'net/http'
	require 'uri'

	
	cattr_accessor :result_array

def self.get_breaking_news(min)
	doc = Hpricot.XML(open("http://www.fatwallet.com/rss_bestdeals.php"))
	
	cutoff_time = Time.now - 60 * min
	
	
#if contains_price_comparison((item/"title").inner_html) && !check_expired((item/"description").inner_html)
	breaking_news = (doc/"item").map do |item|
	  temp_deal = Deal.new
	  temp_deal.name = (item/"title").inner_html
	  temp_deal.description = (item/"description").inner_text
	  temp_deal.buy_link = (item/"link").inner_html 
	  temp_deal.guid = (item/"guid").inner_html
	  temp_deal.cost = get_price(temp_deal.name)
	  temp_deal.cost_retail = get_price_retail(temp_deal.name)
	  
	  unless temp_deal.cost_retail.nil? || temp_deal.cost.nil?
	  	temp_deal.profit_margin = temp_deal.cost_retail - temp_deal.cost
  	  end
	    	  
	  temp_deal.source = "fatwallet"
	  temp_deal	  
	end
end

def self.get_price(name)
	price_value = 0
	
	if name =~ /\(\$(\d+\.\d+) was \$(\d+\.\d+)\)/
		#Wii Fit Plus Game ($12.99 was $19.99) @ Amazon	
		price =  /\(\$(\d+\.\d+) was \$(\d+\.\d+)\)/.match(name)
	elsif name =~ /\(\$(\d+\.\d+) compare at \$(\d+\.\d+)\)/
		#Corsair Flash Voyager 16GB USB 2.0 Flash Drive ($17.99 compare at $34.99) @ Newegg
		price = /\(\$(\d+\.\d+) compare at \$(\d+\.\d+)\)/.match(name)
	end
	
	unless price.nil?
	price_value = price[1].to_f
	end
	return price_value
end

def self.get_price_retail(name)
	price_retail_value = 0
	
	if name =~ /\(\$(\d+\.\d+) was \$(\d+\.\d+)\)/
		#Wii Fit Plus Game ($12.99 was $19.99) @ Amazon	
		price =  /\(\$(\d+\.\d+) was \$(\d+\.\d+)\)/.match(name)
	elsif name =~ /\(\$(\d+\.\d+) compare at \$(\d+\.\d+)\)/
		#Corsair Flash Voyager 16GB USB 2.0 Flash Drive ($17.99 compare at $34.99) @ Newegg
		price = /\(\$(\d+\.\d+) compare at \$(\d+\.\d+)\)/.match(name)
	end
	
	unless price.nil?
	price_retail_value = price[2].to_f
	end
	return price_retail_value
end

def self.get_buy_link(description)
	buy_link = /a href=\s*"([^"]*)/.match(description)
	buy_link[1]
end

def self.contains_price_comparison(name)
	name =~ /\(\$(\d+\.\d+) was \$(\d+\.\d+)\)/ || /\(\$(\d+\.\d+) compare at \$(\d+\.\d+)\)/
end 

def self.check_expired(description)
	description =~ /Expired/ || /expired/
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
