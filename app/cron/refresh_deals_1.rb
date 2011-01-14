class RefreshDeals < ActiveRecord::Base
	# This script refreshes deals from RSS
    dc = DealsController.new
    dc.post_deal_1
end