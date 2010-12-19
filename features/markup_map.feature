Feature:
In order to view the map and customize and add rich data to the map
As a user
I want to be able to add in a custom venue
I want to be able to rate a map
I want to be able to search for directions
	
Scenario: Add in a custom venue
	Given a user is logged in as "user1"
	And I have a pizza map I saved
	And I am viewing my saved map named "pizza in berkeley"	
	When I fill in "add" with "top dog"
	And I press "Add New Venue"
	Then I should see "Top Dog"

#Uses AJAX
#Scenario: Search for directions
#	Given a user is logged in as "user1"
#	And I have a pizza map I saved
#	And I am viewing my saved map named "pizza in berkeley"	
#	When I fill in "input_address" with "Berkeley, CA"
#	And I press "details"
#	And I press "directions to"
#	Then I should see "Google"

#Uses AJAX
#Scenario: Rate a map
#	Given a user is logged in as "user1"
#	And I have a pizza map I saved
#	And I am viewing my saved map named "pizza in berkeley"	
#	When I press "Rate 5 out of 5"
#	And I am viewing my saved map named "pizza in berkeley"
#	Then I should see "Average Rating: 5.0"