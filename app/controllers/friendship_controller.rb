class FriendshipController < ApplicationController
	include ProfileHelper
	
	def create
		@user = current_user
		@friend = User.find_by_username(params[:id])
		#request friendship from user to friend
		Friendship.request(@user, @friend)	
		flash[:notice] = "Friend requested"			
		redirect_to profile_of(@friend)
	end
	
	def accept_friend
		@user = current_user
		@friend = User.find_by_username(params[:id])
		if @user.friends_requested.include?(@friend)
			Friendship.accept_friend(@user,@friend)
			flash[:notice] = "You are now friends with #{@friend.username}."
		else
			flash[:notice] = "Invalid friendship request"
		end
		redirect_to privateprofile_url
	end
	
	def decline_friend
		@user = current_user
		@friend = User.find_by_username(params[:id])
		if @user.friends_requested.include?(@friend)
			Friendship.remove_friend(@user,@friend)
			flash[:notice] = "You have ignored #{@friend.username}'s friend request."
		else
			flash[:notice] = "Invalid friendship request"
		end
		redirect_to privateprofile_url
	end
	
	
	def cancel_friend
		@user = current_user
		@friend = User.find_by_username(params[:id])
		if @user.friends_pending.include?(@friend)
			Friendship.remove_friend(@user,@friend)
			flash[:notice] = "You have cancelled your friend request with #{@friend.username}."
		else
			flash[:notice] = "Invalid friendship request"
		end
		redirect_to privateprofile_url
	end
	
	def remove_existing_friend
		@user = current_user
		@friend = User.find_by_username(params[:id])
		if @user.friends.include?(@friend)
			Friendship.remove_friend(@user,@friend)
			flash[:notice] = "You are no longer friends with #{@friend.username}."
		else
			flash[:notice] = "Invalid friendship request"
		end
		redirect_to privateprofile_url
	end
			
end
