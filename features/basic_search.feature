Feature:
In order to discover venues in a city near a location
As a user
I want to be shown a heatmap based on ratings
I want to be able to search for restaurants (powered by yelp)
I want to be able to search for shopping (powered by yelp)
I want to be able to search for events (powered by eventful)
I want to be able to search for nightlife (powered by yelp)

Scenario: Search by address
	Given I am on the home page
	When I fill in "query" with "pizza"
    And I fill in "location" with "Berkeley"
	And I press "submit"
	Then I should be on the search result page

Scenario: Search by address for restaurants
	Given I am on the home page
	When I fill in "query" with "pizza"
    And I fill in "location" with "Berkeley"
    And I check "restaurants"
	And I press "submit"
	Then I should be on the search result page
	And I should see "pizza"

Scenario: Search by address for shopping
	Given I am on the home page
	When I fill in "query" with "north face"
    And I fill in "location" with "Berkeley"
    And I check "shopping"
	And I press "submit"
	Then I should be on the search result page
	And I should see "North Face"

Scenario: Search by address for events
	Given I am on the home page
	When I fill in "query" with "golden state warriors"
    And I fill in "location" with "oakland"
    And I check "events"
	And I press "submit"
	Then I should be on the search result page
	And I should see "Oracle Arena"
	
Scenario: Search by address for night life
	Given I am on the home page
	When I fill in "query" with "bars"
    And I fill in "location" with "Berkeley"
    And I check "nightlife"
	And I press "submit"
	Then I should be on the search result page
	And I should see "Bear's Lair"		
