Given /^I have a pizza map I searched for$/ do
  fill_in("query", :with => "pizza")
  fill_in("location", :with => "Berkeley")
  check("restaurants")
  click_button("submit")
end

When /^I visit the profile of "(.*)"$/ do |username|
	visit "/profile/#{username}" 
end

Given /^I have a pizza map I saved$/ do
  fill_in("query", :with => "pizza")
  fill_in("location", :with => "Berkeley")
  check("restaurants")
  click_button("submit")
  fill_in("map_title", :with => "pizza in berkeley")
  click_button("save")
end

Given /^"(.*)" is friends with "(.*)"$/ do |user1, user2|
   #create user1	
   @current_user1 = User.create!(:username => "#{user1}", :password => 'generic', :password_confirmation => 'generic', :email => "#{user1}@example.com")
   
   #create user2	
   @current_user2 = User.create!(:username => "#{user2}", :password => 'generic', :password_confirmation => 'generic', :email => "#{user2}@example.com")
   
  #login as user1
  visit "/login" 
  fill_in("username", :with => "#{user1}")
  fill_in("password", :with => 'generic') 
  click_button("Submit")

  #visit profile of user2
  visit "/profile/#{user2}" 
  
  #follow "Add user2 as a friend"
  click_link("Add user2 as a friend")
  
  #logout as user1
  visit "/logout" 
  
  #login as user2
  visit "/login" 
  fill_in("username", :with => "#{user2}") 
  fill_in("password", :with => 'generic') 
  click_button("Submit")
  
  #go to my private profile page
  visit path_to("my private profile page")
  
  #follow "Accept"
  click_link("Accept")
  
  #logout as user2
  visit "/logout"      
end