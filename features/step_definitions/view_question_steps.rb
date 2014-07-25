Then(/^I should see the question page$/) do
  expect(page).to have_css('body.questions.show')
end

Then(/^I should see a comment box$/) do
  expect(page).to have_css('#comment_body')
end

Then(/^I should not see a comment box$/) do
  expect(page).not_to have_css('#comment_body')
end
