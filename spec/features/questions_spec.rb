require 'spec_helper'

describe "posting a new question" do
  let(:question) { FactoryGirl.build(:question) }
  it "submits a new question", js: true do
    pending
    visit '/'
    first(:link, "Ask a Question").click
    within("#new_question") do
      fill_in 'What would you like to ask the mayoral candidates?', with: question.body
      fill_in 'Name', with: question.name
      fill_in 'Email', with: question.email
      click_on 'Ask'
    end
    expect(page).to have_content 'Thanks for contributing!'
  end
end
