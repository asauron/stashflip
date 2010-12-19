require 'spec_helper'
	
describe Friendship do
  before(:each) do
  	User.create!(:username => "irvine", :id => 100, :email => "anteater@uci.edu", :password => "letmein", :password_confirmation => "letmein")	
  	User.create!(:username => "sandiego", :id => 200, :email => "san@ucsd.edu", :password => "letmein", :password_confirmation => "letmein")      
  	@user1 = User.find_by_username("irvine")
  	@user2 = User.find_by_username("sandiego")
  end

  it "should initiate a friend request and have the friendship table set pending for the first user and requested for the second user" do
	Friendship.request(@user1, @user2)
	friendship1 = Friendship.find_by_user_id_and_friend_id(@user1, @user2)
	friendship2 = Friendship.find_by_user_id_and_friend_id(@user2, @user1)
	friendship1.status.should == 'pending'
	friendship2.status.should == 'requested'    
  end
  
  it "should accept a friend request and have the friendship table set accepted for the first user and accepted for the second user" do
	Friendship.request(@user1, @user2)
	Friendship.accept_friend(@user1, @user2)
	friendship1 = Friendship.find_by_user_id_and_friend_id(@user1, @user2)
	friendship2 = Friendship.find_by_user_id_and_friend_id(@user2, @user1)
	friendship1.status.should == 'accepted'
	friendship2.status.should == 'accepted'    
  end
  
  it "should remove a friendship and have the friendship table remove the friendship" do
	Friendship.request(@user1, @user2)
	Friendship.remove_friend(@user1, @user2)
	Friendship.already_friends?(@user1, @user2).should == false
  end  
    
end
