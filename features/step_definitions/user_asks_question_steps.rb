Then(/^I should be told that the question was successfully posted$/) do
  expect(page).to have_content('Great question. So great you should probably share it...')
end

Then(/^I should be taken to the new questions list$/) do
  expect(page).to have_css('body.questions.new_questions')
end

Then(/^I should see my question at the top of the list$/) do
  expect(page).to have_content(@question_body)
end

When(/^I fill out the ask question form with "(.*?)"$/) do |arg1|
  @question_body = arg1
  fill_in 'question_body', with: @question_body
  click_on 'Ask question'
end

Then(/^I should not see my question$/) do
  expect(page).not_to have_content(@question_body)
end
