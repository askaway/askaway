Given(/^there is a party$/) do
  @party = FactoryGirl.create(:party)
end

When(/^I visit the party page$/) do
  visit party_path(@party)
end

When(/^I fill in the new member form$/) do
  @emails = %w(gibby@example.com jon@example.com me@woah.com)
  @invitation_emails = "\"Gibby Jibbly\" <#{@emails[0]}>, #{@emails[1]}, #{@emails[2]}"
  fill_in 'invite_members_form_emails', with: @invitation_emails
  click_on 'invite-btn'
end

Then(/^I should see a message telling me members have been invited$/) do
  expect(page).to have_content('Members invited.')
end

Then(/^emails should be sent to the members I invited$/) do
  @emails.each do |email|
    open_email(email)
    expect(current_email).not_to be_nil
  end
end

Then(/^I should see their emails in a list of invited members$/) do
  expect(page).to have_content('3 invitations sent')
end

Then(/^I should see the party walkthrough page$/) do
  expect(page).to have_css('body.party.walkthrough')
end

Given(/^I have been invited to join a party$/) do
  @party = FactoryGirl.create(:party)
  @name = 'Jon'
  @email = 'jon@example.org'
  @inviter = FactoryGirl.create(:user)
  @invitation = Invitation.invite!(invitable: @party,
                                   intent: 'to_join_party',
                                   name: @name,
                                   email: @email,
                                   inviter: @inviter)
end

When(/^I visit the invitation link sent to me in my email$/) do
  open_email(@email)
  current_email.click_link "invitation-link"
end

When(/^I visit the invitation link again$/) do
  current_email.click_link "invitation-link"
end

When(/^I create an account$/) do
  @password = 'password'
  form = find('.simple_form.new_user')
  form.fill_in :user_name, with: @name
  form.fill_in :user_email, with: @email
  form.fill_in :user_password, with: @password
  form.fill_in :user_password_confirmation, with: @password
  click_on 'Create account'
end

Then(/^I should see the party page$/) do
  expect(page).to have_css('body.party.show')
end

Then(/^I should see my name under the list of members$/) do
  find('.party-members').should have_content(@name)
end

When(/^I visit the party new members page$/) do
  visit new_members_party_path(@party)
end

Then(/^I should be added to the party$/) do
  expect(@party.reload.members).to include(User.last)
end

Then(/^I should see party walkthrough page$/) do
  expect(page).to have_css('body.parties.walkthrough')
end
