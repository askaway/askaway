require 'spec_helper'

describe 'Sign up' do
  let(:user) { FactoryGirl.build(:user) }
  it 'Should create new user', js: true do
    visit root_path
    click_link 'Registration'
    within('#registrationModal') do
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      fill_in 'user_password_confirmation', with: user.password
      click_button 'Sign up'
    end
    expect(page).to have_content(user.email)
    expect(User.where(email: user.email)).to exist
  end
end
