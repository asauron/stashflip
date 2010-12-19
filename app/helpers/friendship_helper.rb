module FriendshipHelper
	def friendship_state(user, friend)
			friendship = Friendship.find_by_user_id_and_friend_id(user, friend)
			if (user==friend)
			end
			if friendship.nil?
				return "You are not friends with #{friend.username}"
			end
			
			case friendship.status
			when 'requested'
				return "#{friend.username} wants to be your friend"			
			when 'pending'
				return "You are asking #{friend.username} to be your friend"
			when 'accepted'
				return "You are friends with #{friend.username}"
			end
		end
end
