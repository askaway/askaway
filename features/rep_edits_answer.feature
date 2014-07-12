Feature: Rep edits question

  Scenario: Rep edits question
    Given I am logged in
    And I am rep for a party
    And there is a question I have answered
    When I visit the question
    And I click "Edit"
    And I change my answer
    Then I should see my new answer on the question

  Scenario: User cannot edit question
    Given I am logged in
    And there is a question with an answer
    When I visit the question
    Then I should not see 'Edit'

  Scenario: Visitor sees revision history
    Given there is a question with an answer
    And the answer has been edited
    When I visit the question
    And I click edit
    Then I should see the question revision history
