Feature: Site admin invites rep to party
  As a site admin
  I want to invite someone to be a rep for a party
  So they can get ready to answer questions

  Scenario: Site admin invites rep to party
    Given I am logged in as an admin
    And there is a party
    When I visit the party page
    And I fill in the new member form
    Then I should see a message telling me reps have been invited
    Then an email should be sent to the rep I invited
    And I should see their name listed as invited

  Scenario: Visitor accepts invitation to party
    Given I have been invited to join a party
    When I visit the invitation link sent to me in my email
    And I create an account
    Then I should see party walkthrough page
    And I should be added to the party

    When I visit the invitation link again
    Then I should see "invitation may have already been used"

  Scenario: User accepts invitation to party

  Scenario: Normal user cannot invite reps to party
    Given I am logged in
    And there is a party
    When I visit the party page
    Then I should not see "Invite"
