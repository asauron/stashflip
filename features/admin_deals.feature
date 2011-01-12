Feature:
In order to refresh deals
As an admin
I want to be able to be able to refresh new deals from Black Friday Ads, Deal News, and Cheap Game Deals
I want to be add a new deal
I want to be able to delete a deal

Scenario: Add a new deal
	Given I am on the home page
	When I fill in "query" with "pizza"
    And I fill in "location" with "Berkeley"
	And I press "submit"
	Then I should be on the search result page