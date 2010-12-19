class Map < ActiveRecord::Base
  belongs_to :user
  has_one :map_filter
  
  ajaxful_rateable :stars => 5#, :dimensions => [:speed, :beauty, :price]

  def self.top_rated_maps
	@top_rated_maps = Map.find(:all)
	@top_rated_maps.sort! {|a,b| b.rating_average <=> a.rating_average}
  end
  
def self.top_friends_maps(current_user)
	@top_friends_maps = []
	@friends = current_user.friends	
	@friends.each do |friend|
		friend_maps = Map.find(:all, :conditions => {:user_id => friend.id})
		random_map = friend_maps[rand(friend_maps.length)]
		@top_friends_maps << random_map		
	end
	return @top_friends_maps
end

def self.top_category_maps(category_type)
	@top_restaurant_maps = []
	@maps = Map.find(:all)
	@maps.each do |map|
		map_filter =MapFilter.find(:first, :conditions => {:map_id => map.id, :category=> category_type})
		unless map_filter.nil?
			@top_restaurant_maps << Map.find(:first, :conditions => {:id => map_filter.map_id}) 
		end
	end
	#sort the top maps in a category by ranking
	@top_restaurant_maps.sort! {|a,b| b.rating_average <=> a.rating_average}
	#return the top maps in a category 
	return @top_restaurant_maps
end

end