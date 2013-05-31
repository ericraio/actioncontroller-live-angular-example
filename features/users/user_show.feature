Feature: Show Users
  As a visitor to the website
  I want to see registered users listed on the homepage
  so I can know if the site has users

    Scenario: Viewing a user profile
      Given I exist as a user
      When I visit my user profile screen
      Then I should see my name

    Scenario: Following a user from their profile
      Given I exist as a user
      And another user exists
      And I am logged in
      When I visit a user profile screen
      Then I should see their name

      When I click follow for the user
      Then I should be following the user
      And the screen should say following
      And the screen should not say follow

    Scenario: Unfollowing a user from their profile
      Given I exist as a user
      And another user exists
      And I am logged in
      When I am following the user
      And I visit a user profile screen
      And I click following for the user

      Then I should not be following the user
      And the screen should say follow
      And the screen should not say following

    Scenario: Current user, no follow button
      Given I exist as a user
      When I visit my user profile screen
      Then I should see my name
      And the screen should not say follow
      And the screen should not say following
