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
		else
			false
		end	
	end	

end
