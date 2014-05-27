When(/^I visit question page$/) do
  @question = FactoryGirl.create(:question)
  visit question_path(@question)
end

When(/^I fill out the comment form$/) do
  @comment_body = Faker::Lorem.paragraph
  fill_in 'comment_body', with: @comment_body
  click_on 'Post Comment'
end

Then(/^I should see my comment at the top of the list$/) do
  page.should have_content(@comment_body)
end
