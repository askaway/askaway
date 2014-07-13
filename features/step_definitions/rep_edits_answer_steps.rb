Given(/^there is a question I have answered$/) do
  @question = FactoryGirl.create(:question)
  @answer = FactoryGirl.create(:answer, question: @question, rep: @rep)
end

When(/^I change my answer$/) do
  @new_body = 'my new shiiit'
  fill_in :answer_body, with: @new_body
  click_on "Update answer"
end

Then(/^I should see my new answer on the question$/) do
  visit question_path(@question)
  expect(page).to have_content(@new_body)
end

Given(/^there is a question with an answer$/) do
  @question = FactoryGirl.create(:question)
  @answer = FactoryGirl.create(:answer, question: @question)
end

Given(/^the answer has been edited$/) do
  @old_body = @answer.body
  @new_body = "yoyuoyoy oy oy yoo"
  @answer.edited_at = Time.zone.now
  @answer.update_attributes(body: @new_body)
end

Then(/^I should see the question revision history$/) do
  expect(page).to have_content(@new_body)
end
