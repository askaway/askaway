Feature: View question

  Scenario: Visitor views question
    Given there is a question with a comment
    When I visit the question
    Then I should see the question page

  Scenario: User views question
    Given I am logged in
    And there is a question with a comment
    When I visit the question
    Then I should see the question page

  Scenario: Rep views question
    Given I am logged in
    And I am rep for a party
    Given there is a question with a comment
    When I visit the question
    Then I should see the question page
    Then I should not see a comment box

  Scenario: Rep views question they have answered
    Given I am logged in
    And I am rep for a party
    Given there is a question with a comment
    And I have answered the question
    When I visit the question
    Then I should see the question page
    Then I should see a comment box

  Scenario: Site admin views question
    Given I am logged in as an admin
    And there is a question with a comment
    When I visit the question
    Then I should see the question page
