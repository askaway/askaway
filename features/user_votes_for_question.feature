Feature: User votes for question
  As a user
  I want to vote for questions I like
  so that they are more likely to get answered

  @javascript
  Scenario: User votes for question
    Given I am logged in
    And there is a question
    And I am on the home page
    When I click on the vote arrow
    Then I should see the vote number increase by one

  @javascript
  Scenario: Guest tries to vote for question
    Given there is a question
    And I am on the home page
    When I click on the vote arrow
    Then I should be asked to log in
