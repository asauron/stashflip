class DeleteOldDeals < ActiveRecord::Base
	# This script deletes deals older than 1 week
    dc = DealsController.new
    dc.delete_old_deals
end