Given /^I have searched for "([^"]*)" near "([^"]*)"$/ do |query, location|
  Given 'I am on the home page'
  And 'I fill in "query" with "' + query + '"'
  And 'I fill in "location" with "' + location + '"'
	And 'I press "submit"'
end

Then /^I should see "([^"]*)" above "([^"]*)"$/ do |arg1, arg2|
  Then 'I should see "' + arg1 + '"'
  And 'I should see "' + arg2 + '"'
end
