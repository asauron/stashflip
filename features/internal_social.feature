Feature:
In order to take advantage of social networking on the website internally and discover new maps
As a user
I want to be able to save maps
I want to be able to favorite maps
I want to be able to have friends
I want to be able to view other user maps
I want to be able to see top maps on the front page
I want to be able to see friends' maps on the front page
	
Scenario: Save a map
	Given a user is logged in as "user1"
	And I have a pizza map I searched for
	And I fill in "map_title" with "pizza in berkeley"
	And I press "save"
	Then I should be on my private profile page
	And I should see "pizza in berkeley"
	
Scenario: Favorite a map
	Given a user is logged in as "user1"
	And I have a pizza map I saved
	And I logout
	And a user is logged in as "user2"
	And I visit the profile of "user1"
	And I follow "pizza in berkeley"
	When I press "Add to Favorites"
	Then I should be on my private profile page
	And I should see "pizza in berkeley"
	
Scenario: View a public profile of another user
	Given I have a user named "user1"	
	And I have a user named "user2"
	And I am logged in as "user1"
	When I visit the profile of "user2"
	Then I should see "user2"

Scenario: Add a friend (asking)
	Given I have a user named "user1"	
	And I have a user named "user2"
	And I am logged in as "user1"
	When I visit the profile of "user2"
	And I follow "Add user2 as a friend"
	Then I should see "You are asking user2 to be your friend"	
	
Scenario: Add a friend (accept)
	Given I have a user named "user1"	
	And I have a user named "user2"
	And I am logged in as "user1"
	When I visit the profile of "user2"
	And I follow "Add user2 as a friend"
	And I logout
	And I am logged in as "user2"
	And I am on my private profile page
	And I follow "Accept"
	Then I should see "You are now friends with user1"

Scenario: Add a friend (decline)
	Given I have a user named "user1"	
	And I have a user named "user2"
	And I am logged in as "user1"
	When I visit the profile of "user2"
	And I follow "Add user2 as a friend"
	And I logout
	And I am logged in as "user2"
	And I am on my private profile page
	And I follow "Decline"
	Then I should see "You have ignored user1's friend request"

Scenario: View other user maps
	Given a user is logged in as "user1"
	And I have a pizza map I saved
	And I logout
	When a user is logged in as "user2"
	And I visit the profile of "user1"
	And I follow "pizza in berkeley"
	Then I should see "pizza in berkeley"

Scenario: View top maps on the front page
	Given a user is logged in as "user1"
	And I have a pizza map I saved
	When I am on the home page
	Then I should see "pizza in berkeley"

Scenario: View friends' maps on the front page
	Given "user1" is friends with "user2"
	And I am logged in as "user1"
	And I have a pizza map I saved
	And I logout
	When I am logged in as "user2"
	And I am on the home page
	Then I should see "pizza in berkeley"