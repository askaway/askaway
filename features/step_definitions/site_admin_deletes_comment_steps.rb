Given(/^there is a question with a comment$/) do
  step 'there is a question'
  @comment = FactoryGirl.create(:comment, question: @question)
end

Then(/^the comment should no longer exist$/) do
  expect{@comment.reload}.to raise_error(ActiveRecord::RecordNotFound)
end
