Feature: Game Show
  As a visitor to the website
  I want to see a game page
  So I can rate it, like it or comment on it

  Scenario: Viewing games
    Given I exist as a user
    When I look at a game page
    Then I should see the game title
