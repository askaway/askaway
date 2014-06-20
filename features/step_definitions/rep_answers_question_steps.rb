Given(/^I am rep for a party$/) do
  @rep = FactoryGirl.create(:rep, user: @user)
end

When(/^I visit the question$/) do
  visit question_path(@question)
end

When(/^I fill in and submit the answer form$/) do
  @answer_count = @question.answers_count
  fill_in 'answer_body', with: Faker::Lorem.paragraph
  click_on 'post-answer-btn'
end

Then(/^my answer should be posted and it should appear on the question$/) do
  expect(@question.reload.answers_count).to eq(@answer_count + 1)
end
