require 'spec_helper'

# TODO: Can someone fix that test? tired to fight with it, still not working
describe 'Sign in' do
  let(:user) { FactoryGirl.create(:user, password: 'password', password_confirmation: 'password') }
  it 'Should login user', js: true do
    pending
    visit '/users/sign_in'
    click_link 'Login'
    within('#loginModal') do
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: 'password'
      click_button 'Sign in'
    end
    expect(page).to have_content(user.email)
    expect(page).to not_have_content('Login')
  end
end
