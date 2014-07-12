Given(/^there is a question I have answered$/) do
  @question = FactoryGirl.create(:question)
  @answer = FactoryGirl.create(:answer, question: @question, rep: @rep)
end

When(/^I change my answer$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see my new answer on the question$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^there is a question with an answer$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should not see 'Edit'$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^the answer has been edited$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I click edit$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see the question revision history$/) do
  pending # express the regexp above with the code you wish you had
end
