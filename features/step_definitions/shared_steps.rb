Given(/^I am logged in$/) do
  email = 'meg@howie.com'
  password = 'password'
  @user = User.create!(name: 'Meg Howie', email: email, password: password)
  visit new_user_session_path
  find('.simple_form.user').fill_in 'user_email', with: email
  find('.simple_form.user').fill_in 'user_password', with: password
  click_on 'log-in-btn'
end

Then(/^I should be asked to log in$/) do
  expect(page).to have_css('body.sessions.new')
end

Given(/^I am on the home page$/) do
  visit '/'
end

When(/^I visit the home page$/) do
  visit '/'
end

When(/^I click on "(.*?)"$/) do |arg1|
  click_on arg1
end
