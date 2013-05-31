When /^I visit the dashboard screen$/ do
  #page.driver.debug
  visit '/'
end

Then /^I should see an edit profile link in the sidebar$/ do
  page.should have_content "Edit Profile"
end

When /^I click on the edit profile link$/ do
  click_link 'Edit Profile'
end

Then /^I should be on the edit profile screen$/ do
  current_path.should == '/user/profile/edit'
end

When /^I visit the edit profile screen$/ do
  visit '/user/profile/edit'
end

Then /^I should be on the sign in screen$/ do
  current_path.should == '/users/sign_in'
end
