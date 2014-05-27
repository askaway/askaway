Feature: User submits comment
  As a user
  I want to comment on a question
  So that I can share my opinion

  Scenario: User submits comment
    Given I am logged in
    When I visit question page
    And I fill out the comment form
    Then I should see my comment at the top of the list
