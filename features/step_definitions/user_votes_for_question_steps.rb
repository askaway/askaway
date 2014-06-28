When(/^I click on the vote arrow$/) do
  find("#vote-for-#{@question.id}").click
end

Then(/^I should see the vote number increase by one$/) do
  expect(find("#question-#{@question.id} .question-up-vote-count")).to(
    have_content(@question.votes_count + 1))
end
