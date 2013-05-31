### UTILITY METHODS ###

def create_visitor
  @visitor ||= {
    :username => "Testy1",
    :email => "example@example.com",
    :password => "changeme",
  }
end

def find_user
  @user ||= User.where(:email => @visitor[:email]).first
end

def create_unconfirmed_user
  create_visitor
  delete_user
  sign_up
  visit '/users/sign_out'
end

def create_user(user = {})
  if user.blank?
    @user ||= FactoryGirl.create(:user)
  else
    @other_user ||= FactoryGirl.create(:user, user)
  end
end

def delete_user
  create_visitor
  @user ||= User.where(:email => @visitor[:email]).first
  @user.destroy unless @user.nil?
end

def sign_up
  fill_in "user_username", :with => @visitor[:username]
  fill_in "user_email", :with => @visitor[:email]
  fill_in "user_password", :with => @visitor[:password]
  click_button "Sign up"
  find_user
end

def sign_in
  create_visitor
  visit '/users/sign_in'
  fill_in "user_email", :with => @visitor[:email]
  fill_in "user_password", :with => @visitor[:password]
  click_button "Sign in"
end

### GIVEN ###
Given /^I am not logged in$/ do
  visit '/users/sign_out'
end

Given /^another user exists$/ do
  create_user({ username: 'Testy2', email: 'example2@example.com', password: 'mysekret'})
end

Given /^I am logged in$/ do
  login_as create_user
end

Given /^I exist as a user$/ do
  create_user
end

Given /^I do not exist as a user$/ do
  create_visitor
  delete_user
end

Given /^I exist as an unconfirmed user$/ do
  create_unconfirmed_user
end

Given /^I visit the sign up screen$/ do
  delete_user
  visit '/users/sign_up'
end

Given /^I visit the home screen$/ do
  create_visitor
  delete_user
  visit '/'
end

### WHEN ###

When /^I click following for the user$/ do
  click_link 'Following'
end

When /^I visit my user profile screen$/ do
  visit '/testy1'
end

When /^I visit a user profile screen$/  do
  visit '/testy2'
end

When /^I click follow for the user$/ do
  click_link 'Follow'
end

When /^I am following the user$/ do
  @user.follow(@other_user)
end

When /^I sign in with valid credentials$/ do
  create_visitor
  sign_in
end

When /^I sign out$/ do
  visit '/users/sign_out'
end

When /^I sign up with valid user data$/ do
  create_visitor
  sign_up
end

When /^I sign up with an invalid email$/ do
  create_visitor
  @visitor = @visitor.merge(:email => "notanemail")
  sign_up
end

When /^I sign up with an email taken by another user$/ do
  create_visitor
  create_user
  sign_up
end

When /^I sign up with a username taken by another user$/ do
  create_visitor
  create_user
  sign_up
end

When /^I sign up without a password$/ do
  create_visitor
  @visitor = @visitor.merge(:password => "")
  sign_up
end

When /^I sign up without a username/ do
  create_visitor
  @visitor = @visitor.merge(:username => "")
  sign_up
end

When /^I sign up without an email/ do
  create_visitor
  @visitor = @visitor.merge(:email => "")
  sign_up
end

When /^I return to the site$/ do
  visit '/'
end

When /^I sign in with a wrong email$/ do
  create_visitor
  @visitor = @visitor.merge(:email => "wrong@example.com")
  sign_in
end

When /^I sign in with a wrong password$/ do
  create_visitor
  @visitor = @visitor.merge(:password => "wrongpass")
  sign_in
end

When /^I edit my account details$/ do
  click_link "Edit account"
  click_button "Update"
end

When /^I look at the list of users$/ do
  visit '/'
end

### THEN ###
Then /^I should not be following the user$/ do
  @user.follower_of?(@other_user).should be_false
end

Then /^I should be signed in$/ do
  page.should have_content "Sign out"
  page.should_not have_content "Sign up"
  page.should_not have_content "Sign in"
end

Then /^I should be signed out$/ do
  page.should have_content "Sign up"
  page.should have_content "Sign in"
  page.should_not have_content "Sign out"
end

Then /^I should be following the user$/ do
  @user.follower_of?(@other_user).should be_true
end

Then /^the screen should say following$/ do
  page.should have_content "Following"
end

Then /^the screen should say follow$/ do
  page.should have_content "Follow"
end

Then /^I see an unconfirmed account message$/ do
  page.should have_content "You have to confirm your account before continuing."
end

Then /^I see a successful sign in message$/ do
  page.should have_content "Signed in successfully."
end

Then /^I should see their name$/ do
  page.should have_content @other_user[:username]
end

Then /^I should see a successful sign up message$/ do
  page.should have_content "Welcome! You have signed up successfully."
end

Then /^I should see an invalid email message$/ do
  page.should have_content "is invalid"
end

Then /^I should see a signed out message$/ do
  page.should have_content "Signed out successfully."
end

Then /^I see an invalid login message$/ do
  page.should have_content "Invalid email or password."
end

Then /^I should see an account edited message$/ do
  page.should have_content "You updated your account successfully."
end

Then /^I should see my name$/ do
  create_user
  page.should have_content @user[:username]
end

Then /^I should see a missing password message$/ do
  page.should have_content "can't be blank"
end

Then /^I should see a missing username message$/ do
  page.should have_content "can't be blank"
end

Then /^I should see an email taken message$/ do
  page.should have_content "is already taken"
end

Then /^I should see a username taken message$/ do
  page.should have_content "is already taken"
end

Then /^I should see a missing email message$/ do
  page.should have_content "can't be blank"
end

Then /^the screen should not say follow$/ do
  page.should_not have_content "follow"
end

Then /^the screen should not say following$/ do
  page.should_not have_content "following"
end
