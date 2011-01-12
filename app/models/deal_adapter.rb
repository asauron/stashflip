class DealAdapter < ActiveRecord::Base
	require 'rubygems'
	require 'hpricot'
	require 'open-uri'
	require 'net/http'
	require 'uri'
	
	def self.contains_price_comparison(latest_deal)
		case latest_deal.source
		when "bfads" then BfadsDelegate.contains_price_comparison(latest_deal.description)			
		when "dealnewslaptop" then DealnewslaptopDelegate.contains_price_comparison(latest_deal.name)
		when "dealnewsvideogames" then DealnewsvideogamesDelegate.contains_price_comparison(latest_deal.name)
		when "dealnewshdtv" then DealnewsvideogamesDelegate.contains_price_comparison(latest_deal.name)
		when "cheapgamedeals" then DealnewsvideogamesDelegate.contains_price_comparison(latest_deal.name)			
		else
			false
		end	
	end	
	
	def self.get_shipping_cost(name)
		case name
		when /Amazon/ then 0
		when /Lowe's/ then 6
		when /Tiger/ then 4
		when /TigerDirect/ then 4					
		when /Dell/ then 0
		when /Buy\.com/ then 0
		when /Cowboom/ then 5
		when /DailySteals\.com/ then 5	
		when /Newegg/ then 5
		when /Woot/ then 5
		when /Walmart/ then 0
		when /Deep Discount/ then 0
		when /Office Depot/ then 0
		when /Office Max/ then 0
		when /Staples/ then 0
		when /BestBuy/ then 6
		when /Best Buy/ then 6							
		else 
			0
		end
	end

end
