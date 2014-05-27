When(/^I visit the home page$/) do
  visit '/'
end

When(/^I click on "(.*?)"$/) do |arg1|
  click_on arg1
end

When(/^I fill out the ask question form$/) do
  fill_in "question_body", with: "hey, why does the government exist?"
  fill_in "question[name]", with: "Jay Stooo"
  fill_in "question[email]", with: "jay@stooo.com"
  click_on "Ask"
end

Then(/^I should be told that the question was successfully posted$/) do
  page.should have_content("Question was successfully created.")
end
