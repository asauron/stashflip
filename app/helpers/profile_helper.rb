module ProfileHelper
	
	#url helper for profile of a user
	def profile_of (user)
		profile_url(:username => user.username)
	end
end
