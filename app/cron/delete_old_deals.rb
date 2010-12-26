class DeleteOldDeals < ActiveRecord::Base
  # This script deletes all posts that are over 5 minutes old

    deal_ids = Deal.find(:all, :conditions => ["created_at < ? and permadeal = ?", 2.minutes.ago, 'no'])

  if deal_ids.size > 0
    Deal.destroy(deal_ids)
    puts "#{deal_ids.size} deals have been deleted!"
  end

end