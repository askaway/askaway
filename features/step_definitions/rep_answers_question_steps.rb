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

Then(/^an email should be sent to who asked the question$/) do
  open_email(@question.user.email)
  expect(current_email).not_to be_nil
  expect(current_email.subject).to eq("Your question has been answered by the #{@rep.party.name}")
end
