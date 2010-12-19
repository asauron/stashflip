class Friendship < ActiveRecord::Base
	validates_presence_of :user_id, :friend_id	
	belongs_to :user
	belongs_to :friend, :class_name => 'User', :foreign_key => 'friend_id'
	
	#Return true if users are already friends
	def self.already_friends?(user,friend)
		find_by_user_id_and_friend_id(user,friend) != nil
	end
	
	#Initiate pending friendship
	#2 entries in the database have to be saved for each friendship
	#1st entry is for user_id, friend_id, status = pending
	#2nd entry is for friend_id, user_id, status = requested	
	def self.request(user,friend)
		unless Friendship.already_friends?(user,friend) or (user == friend)
			transaction do
				create(:user => user, :friend => friend, :status => 'pending')
				create(:user => friend, :friend => user, :status => 'requested')
			end
		end
	end
		
	#Accept a friend
	#2 entries in the database have to be saved for each friendship
	#1st entry is for user_id, friend_id, time_accepted
	#2nd entry is for friend_id, user_id, time_accepted 
	def self.accept_friend(user,friend)
		transaction do
			time_accepted = Time.now
			transaction do
				accept_entry(user, friend, time_accepted)
				accept_entry(friend, user, time_accepted)
			end
		end
	end
	
	#Helper method for accepting a friend	
	def self.accept_entry(user, friend, time_accepted)
		entry = find_by_user_id_and_friend_id(user, friend)
		entry.status = 'accepted'
		entry.time_accepted = time_accepted
		entry.save!
	end
	
	#Delete friendship
	def self.remove_friend(user, friend)
		transaction do
			destroy(find_by_user_id_and_friend_id(user,friend))
			destroy(find_by_user_id_and_friend_id(friend,user))
		end
	end
	
end
