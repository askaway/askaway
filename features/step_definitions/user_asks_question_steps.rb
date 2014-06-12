When(/^I fill out the ask question form$/) do
  @question_body = 'hey, why does the government exist?'
  fill_in 'question_body', with: @question_body
  click_on 'Ask question'
end

Then(/^I should be told that the question was successfully posted$/) do
  expect(page).to have_content('Your question has been posted.')
end

Then(/^I should be taken to the new questions list$/) do
  expect(page).to have_css('body.questions.new_questions')
end

Then(/^I should see my question at the top of the list$/) do
  expect(page).to have_content(@question_body)
end
