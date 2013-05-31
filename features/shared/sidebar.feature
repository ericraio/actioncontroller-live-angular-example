Feature: Sidebar
  As a user on the website
  I want to see a sidebar 
  In order to navigate around the side

  Scenario: Edit Profile
    Given I exist as a user
    And I am logged in
    When I visit the dashboard screen
    Then I should see an edit profile link in the sidebar

    When I click on the edit profile link
    Then I should be on the edit profile screen

  Scenario: Try to Edit Profile When Not Logged In
    Given I am not logged in
    When I visit the edit profile screen
    Then I should be on the sign in screen
