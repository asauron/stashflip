Given /^a user is logged in as "(.*)"$/ do |login|
  @current_user = User.create!(
    :username => login,
    :password => 'generic',
    :password_confirmation => 'generic',
    :email => "#{login}@example.com"
  )

  # :create syntax for restful_authentication w/ aasm. Tweak as needed.
  # @current_user.activate! 

  visit "/login" 
  fill_in("username", :with => login) 
  fill_in("password", :with => 'generic') 
  click_button("Submit")
end

Given /^I have a user named "(.*)"$/ do |login|
  @current_user = User.create!(
    :username => login,
    :password => 'generic',
    :password_confirmation => 'generic',
    :email => "#{login}@example.com"
  )
end

Given /^I am logged in as "(.*)"$/ do |login|
  visit "/login" 
  fill_in("username", :with => login) 
  fill_in("password", :with => 'generic') 
  click_button("Submit")
end

Given /^I logout$/ do
  visit "/logout" 
end