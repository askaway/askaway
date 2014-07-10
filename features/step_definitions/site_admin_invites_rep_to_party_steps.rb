Given(/^there is a party$/) do
  @party = FactoryGirl.create(:party)
end

When(/^I visit the party page$/) do
  visit party_path(@party)
end

When(/^I fill in the new member form$/) do
  @email = 'jacob@appleberry.com'
  @name = 'Jacob Appleberry'
  fill_in 'invitation_name', with: @name
  fill_in 'invitation_email', with: @email
  click_on 'Invite'
end

Then(/^I should see a message telling me reps have been invited$/) do
  expect(page).to have_content('Invited')
end

Then(/^an email should be sent to the rep I invited$/) do
  open_email(@email)
  expect(current_email).not_to be_nil
end

Then(/^I should see their emails in a list of invited reps$/) do
  expect(page).to have_content('3 invitations sent')
end

Then(/^I should see the party walkthrough page$/) do
  expect(page).to have_css('body.party.walkthrough')
end

Given(/^I have been invited to join a party$/) do
  @party = FactoryGirl.create(:party)
  @invitation = FactoryGirl.create(:invitation, invitable: @party)
end

When(/^I visit the invitation link sent to me in my email$/) do
  open_email(@invitation.email)
  current_email.click_link "invitation-link"
end

When(/^I visit the invitation link again$/) do
  current_email.click_link "invitation-link"
end

When(/^I create an account$/) do
  @password = 'password'
  form = find('.simple_form.new_user')
  form.fill_in :user_name, with: @invitation.name
  form.fill_in :user_email, with: @invitation.email
  form.fill_in :user_password, with: @password
  form.fill_in :user_password_confirmation, with: @password
  click_on 'Create account'
end

Then(/^I should see the party page$/) do
  expect(page).to have_css('body.party.show')
end

Then(/^I should see my name under the list of reps$/) do
  find('.party-reps').should have_content(@name)
end

When(/^I visit the party new reps page$/) do
  visit new_reps_party_path(@party)
end

Then(/^I should be added to the party$/) do
  expect(@party.reload.rep_users).to include(User.last)
end

Then(/^I should see party walkthrough page$/) do
  expect(page).to have_css('body.parties.walkthrough')
end

Then(/^I should see their name listed as invited$/) do
  expect(page).to have_content("#{@name} (invited)")
end
