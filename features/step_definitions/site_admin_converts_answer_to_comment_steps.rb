Then(/^the answer should no longer exist$/) do
  expect{ @answer.reload }.to raise_error(ActiveRecord::RecordNotFound)
end

Then(/^a comment should exist with the old answer's body$/) do
  expect(@question.comments.last.body).to eq(@answer.body)
end

Given(/^I have answered a question$/) do
  @question = FactoryGirl.create(:question)
  @answer = FactoryGirl.create(:answer, rep: @rep, question: @question)
end
