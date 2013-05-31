Feature: User Dashboard

  As a logged in user
  I want to see my dashboard
  In order to see and share new ideas

  Scenario: Adding a new post
    Given I am logged in
    When I visit the dashboard screen
    And I make a new post
    Then I should be on the dashboard screen
    And I should see my post in the news feed
    And I should see a new post success message

  Scenario: Click on headlines
    Given I am logged in
    When I visit the dashboard screen
    And I make a new post
    And I click on a headline
    Then I should be on the posts screen
    Then I should see the posts content

  @javascript
  Scenario: Seeing my posts in order
    Given I am logged in
    When I follow my friend
    And My friend makes a new post
    And I make a new post
    And I visit the dashboard screen
    Then I should see my friends posts before my post

  @javascript
  Scenario: Seeing my posts live
    Given I am logged in
    When I follow my friend
    And I visit the dashboard screen
    And My friend makes a new post
    Then I should see his post appear on the page
