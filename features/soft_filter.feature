Feature: Soft Filter
As a tourist,
I want to specify how the nodes are weighted
So that I can better weigh my results to fit my tastes.

Scenario: Soft filter with all fields selected
	Given I have searched for "pizza" near "Berkeley"
	When I select "Negligible" from "num_ratings_weight"
	And I select "Crucial" from "avg_rating_weight"
	And I select "Relevant" from "cheapness_weight"
	And I press "submit"
	Then I should be on the search result page
	And I should see "The Cheeseboard Pizza Collective" above "Emilia's Pizzeria"
	
Scenario: Soft filter with some fields unselected
	Given I have searched for "pizza" near "Berkeley"
	When I select "Negligible" from "avg_rating_weight"
	And I press "submit"
	Then I should be on the search result page
	And I should see "Bobby G's Pizzeria" above "Emilia's Pizzeria"

Scenario: Soft filter with none of the fields selected
	Given I have searched for "pizza" near "Berkeley"
	And I press "submit"
	Then I should be on the search result page
	And I should see "Jupiter" above "The Cheeseboard Pizza Collective"
