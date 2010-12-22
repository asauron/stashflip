class DealAdapter < ActiveRecord::Base
	require 'rubygems'
	require 'hpricot'
	require 'open-uri'
	require 'net/http'
	require 'uri'
	
	def self.contains_price_comparison(latest_deal)
		case latest_deal.source
		when "passwird" then PasswirdDelegate.contains_price_comparison(latest_deal.description)
		when "bensbargains" then BensbargainsDelegate.contains_price_comparison(latest_deal.description)
		when "fatwallet" then FatwalletDelegate.contains_price_comparison(latest_deal.name)
		else
			false
		end	
	end	
	
	def self.adjust_profit_margin_by_retailer(profit, name)
		case name
		when /Amazon/ then profit-0
		when /Lowe's/ then profit-6
		when /Tiger/ then profit-4
		when /TigerDirect/ then profit-4					
		when /Dell/ then profit-0
		when /Buy\.com/ then profit-0
		when /Cowboom/ then profit-5
		when /DailySteals\.com/ then profit-5	
		when /Newegg/ then profit-5
		when /Woot/ then profit-5
		when /Walmart/ then profit-0
		when /Deep Discount/ then profit-0
		when /Office Depot/ then profit-0
		when /Office Max/ then profit-0
		when /Staples/ then profit-0
		when /BestBuy/ then profit-6
		when /Best Buy/ then profit-6							
		else 
			profit
		end
	end

end
