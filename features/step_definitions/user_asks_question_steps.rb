When(/^I visit the home page$/) do
  visit '/'
end

When(/^I click on "(.*?)"$/) do |arg1|
  click_on arg1
end

When(/^I fill out the ask question form$/) do
  @question_body = 'hey, why does the government exist?'
  fill_in 'question_body', with: @question_body
  fill_in 'question[name]', with: 'Jay Stooo'
  fill_in 'question[email]', with: 'jay@stooo.com'
  click_on 'Ask'
end

Then(/^I should be told that the question was successfully posted$/) do
  page.should have_content('Your question has been posted.')
end

Then(/^I should be taken to the new questions list$/) do
  page.should have_css('body.questions.new_questions')
end

Then(/^I should see my question at the top of the list$/) do
  page.should have_content(@question_body)
end
