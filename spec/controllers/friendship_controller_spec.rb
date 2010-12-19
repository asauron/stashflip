require 'spec_helper'
require 'authlogic/test_case'
include Authlogic::TestCase

describe FriendshipController do
	include ProfileHelper
	
	before (:each) do
		
		User.create!(:username => "irvinex", :id => 300, :email => "anteaterx@uci.edu", :password => "letmein", :password_confirmation => "letmein")	
		User.create!(:username => "sandiegox", :id => 400, :email => "sanx@ucsd.edu", :password => "letmein", :password_confirmation => "letmein")		
		@user1 = User.find_by_username("irvinex")
		@user2 = User.find_by_username("sandiegox")
		
		@controller = FriendshipController.new
	  	@response = ActionController::TestResponse.new			
 	end

	it "should be able to request a friendship" do
  		#login as user1
  		activate_authlogic
  		UserSession.create!(@user1)
  		#user1 requests a friendship with user2
  		get :create, :id => @user2.username
  		assert_response :redirect
  		assert_redirected_to profile_of(@user2)
  		assert_equal "Friend requested", flash[:notice]			  		
	end 
	
	it "should be able to accept a friendship" do
  		#login as user1
  		activate_authlogic
  		UserSession.create!(@user1)
  		#user1 requests a friendship with user2
  		get :create, :id => @user2.username
  		assert_response :redirect
  		assert_redirected_to profile_of(@user2)
		assert_equal "Friend requested", flash[:notice]   			

		#login as user2
		activate_authlogic
  		UserSession.create!(@user2)		
		#user2 accepts friend request
		get :accept_friend, :id => @user1.username
		assert_redirected_to privateprofile_url	  			  		
	end
	
	it "should be able to decline a friendship" do
  		#login as user1
  		activate_authlogic
  		UserSession.create!(@user1)
  		#user1 requests a friendship with user2
  		get :create, :id => @user2.username
  		assert_response :redirect
  		assert_redirected_to profile_of(@user2)
		assert_equal "Friend requested", flash[:notice]   			

		#login as user2
		activate_authlogic
  		UserSession.create!(@user2)		
		#user2 declines friend request
		get :decline_friend, :id => @user1.username
		assert_redirected_to privateprofile_url	  			  		
	end
	
	it "should be able to cancel a pending friendship" do
  		#login as user1
  		activate_authlogic
  		UserSession.create!(@user1)
  		#user1 requests a friendship with user2
  		get :create, :id => @user2.username
  		assert_response :redirect
  		assert_redirected_to profile_of(@user2)
		assert_equal "Friend requested", flash[:notice]   			
	
		#user1 cancels friend request
		get :cancel_friend, :id => @user2.username
		assert_redirected_to privateprofile_url	  			  		
		assert_equal "You have cancelled your friend request with #{@user2.username}.", flash[:notice]
	end
	
	it "should be able to remove an existing friendship" do
		Friendship.request(@user1, @user2)
		Friendship.accept_friend(@user1, @user2)
		friendship1 = Friendship.find_by_user_id_and_friend_id(@user1, @user2)
		friendship2 = Friendship.find_by_user_id_and_friend_id(@user2, @user1)
		
  		#login as user1
  		activate_authlogic
  		UserSession.create!(@user1)
  		#user1 removes an existing friendship with user2
  		get :remove_existing_friend, :id => @user2.username
  		assert_response :redirect
  		assert_redirected_to '/user'
		assert_equal "You are no longer friends with #{@user2.username}.", flash[:notice]  		
	end
end