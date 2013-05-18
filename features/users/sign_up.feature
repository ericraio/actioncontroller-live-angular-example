Feature: Sign up
  In order to get access to protected sections of the site
  As a user
  I want to be able to sign up

    Background:
      Given I am not logged in
      And I visit the sign up screen

    Scenario: User signs up with valid data
      When I sign up with valid user data
      Then I should see a successful sign up message

    Scenario: User signs up with invalid email
      When I sign up with an invalid email
      Then I should see an invalid email message

    Scenario: User signs up without password
      When I sign up without a password
      Then I should see a missing password message
