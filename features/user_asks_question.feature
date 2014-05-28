Feature: User asks question
  As a user
  I want to ask the candidates a question
  So that I can find out if they care about the same things as me

  Scenario: User asks question
    Given I am logged in
    When I visit the home page
    And I click on "Ask a question"
    And I fill out the ask question form
    Then I should be taken to the new questions list
    And I should be told that the question was successfully posted
    And I should see my question at the top of the list
