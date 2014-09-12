Feature: Site admin converts answer to comment
  As a site admin
  I want to convert an answer to a comment
  So the party leaders can answer instead

  @javascript
  Scenario: Site admin converts answer
    Given I am logged in as an admin
    And there is a question with an answer
    When I visit the question
    When I click "Convert"
    Then the answer should no longer exist
    And a comment should exist with the old answer's body

  @javascript
  Scenario: Rep cannot convert comment
    Given I am logged in
    And I am rep for a party
    And I have answered a question
    When I visit the question
    Then I should not see "Convert"

