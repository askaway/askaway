Given(/^I am rep for a party$/) do
  @rep = FactoryGirl.create(:rep, user: @user)
end

When(/^I visit the question$/) do
  visit question_path(@question)
end

When(/^I fill in and submit the answer form$/) do
  @answer_count = @question.answers_count
  fill_in 'answer_body', with: Faker::Lorem.paragraph
  click_on 'post-answer'
end

Then(/^my answer should be posted and it should appear on the question$/) do
  expect(@question.reload.answers_count).to eq(@answer_count + 1)
end

Then(/^an email should be sent to who asked the question$/) do
  open_email(@question.user.email)
  expect(current_email).not_to be_nil
  expect(current_email.subject).to eq("#{@rep.party.name} answered your question!")
end

When(/^I have answered the question$/) do
  @question.answers << FactoryGirl.create(:answer, question: @question, rep: @rep)
end

When(/^I expand the question$/) do
  find("#question-#{@question.id}").click
end

When(/^I fill in and submit the answer form on the question$/) do
  @answer_count = @question.answers_count
  fill_in 'answer-text', with: Faker::Lorem.paragraph
  click_on 'post-answer'
  page.find('.answers-expanded-item') #causes capybara to wait until comment is posted
end
