Feature: User asks question
  As a user
  I want to ask the reps a question
  So that I can find out if they care about the same things as me

  @javascript
  Scenario: User asks question
    Given I am logged in
    When I visit the home page
    And I click on "Ask a question"
    And I fill out the ask question form with "Hey, why does the government exist?"
    Then I should be taken to the new questions list
    And I should be told that the question was successfully posted
    And I should see my question at the top of the list

  @javascript
  Scenario: User asks profane question
    Given I am logged in
    When I visit the home page
    And I click on "Ask a question"
    And I fill out the ask question form with "Yo! What the fuck? This shit craay!!!"
    Then I should be taken to the new questions list
    And I should see "Thanks! Your question will be reviewed"
    And I should not see my question
