require 'spec_helper'

describe UsersController do
  let(:user) { FactoryGirl.create(:user) }

  describe 'POST #update' do
    before do
      sign_in user
      @attrs = { name: 'new name', email: 'new@email.com' }
      post :update, user: @attrs
      user.reload
    end

    it { expect(user.name).to eq(@attrs[:name]) }
    it { expect(user.email).to eq(@attrs[:email]) }
    it { expect(response).to redirect_to(root_url) }
    it { expect(flash[:notice]).to eq('Your profile has been updated.') }
  end
end
