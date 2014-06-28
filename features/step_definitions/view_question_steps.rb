Then(/^I should see the question page$/) do
  expect(page).to have_css('body.questions.show')
end
