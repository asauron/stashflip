Given /^I am viewing my saved map named "(.*)"$/ do |saved_map_name|
  #go to my private profile page
  visit path_to("my private profile page")
  click_link("#{saved_map_name}")
end

When /^(?:|I )press an external link named "([^"]*)"$/ do |name|
  click_button("#{name}")
end

