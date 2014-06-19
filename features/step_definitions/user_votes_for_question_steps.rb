Given(/^there is a question$/) do
  @question = FactoryGirl.create(:question)
end

When(/^I click on the vote arrow$/) do
  click_on "vote-for-#{@question.id}"
end

Then(/^I should see the vote number increase by one$/) do
  expect(find("#question-#{@question.id} .question-up-vote-count")).to(
    have_content(@question.votes_count + 1))
end
