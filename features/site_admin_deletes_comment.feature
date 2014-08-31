Feature: Site admin invites rep to party
  As a site admin
  I want to delete offensive comments
  So I don't get sued

  @javascript
  Scenario: Site admin deletes comment
    Given I am logged in as an admin
    And there is a question with a comment
    When I visit the question
    Then I should see [Delete](/comments/1)
    And I click "Delete"
    Then the comment should no longer exist

  @javascript
  Scenario: User cannot delete comment
    Given I am logged in
    And there is a question with a comment
    When I visit the question
    Then I should not see "Delete"

