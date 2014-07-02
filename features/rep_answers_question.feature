Feature: Rep answers question
  As a rep
  I want to answer questions on behalf of my party
  So that I can communicate our party's stance to the public.

  Scenario: Rep answers question
    Given I am logged in
    And I am rep for a party
    And there is a question
    When I visit the question
    And I fill in and submit the answer form
    Then my answer should be posted and it should appear on the question
    And an email should be sent to who asked the question
