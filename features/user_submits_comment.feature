Feature: User submits comment
  As a user
  I want to comment on a question
  So that I can share my opinion

  @javascript
  Scenario: User submits comment
    Given I am logged in
    When I visit question page
    And I fill out the comment form
    Then I should see my comment at the top of the list
    And I should see my link is autolinked

  @javascript
  Scenario: User posts profane comment
    Given I am logged in
    When I visit question page
    And I fill out the comment form with "Yo! What the fuck? This shit craay!!!"
    Then I should not see my comment in the list
    And I should see "Thanks! Your comment will be reviewed"
