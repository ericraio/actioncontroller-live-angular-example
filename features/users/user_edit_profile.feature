Feature: Edit Profile
  As a logged in user
  I want to edit my profile
  In order for other users to see it

  Scenario: Upload a new profile image
    Given I am logged in
    When I am on the edit profile screen
    And I enter image details
    Then I should see an edit profile success message

  Scenario: Upload a cover photo
    Given I am logged in
    When I am on the edit profile screen
    And I enter cover photo details
    Then I should see an edit profile success message
