require 'spec_helper'

describe UsersController do
  let(:user) { FactoryGirl.create(:user) }

  context 'POST #edit' do
    before do
      sign_in user
      controller.stub(:authorize)
      post :edit
    end

    it { expect(response).to render_template(:edit) }
    it { expect(assigns(:user)).to eq(user) }
    it { expect(controller).to have_received(:authorize).with(user) }
  end

  context 'POST #update' do
    before do
      sign_in user
      @attrs = { name: 'new name', email: 'new@email.com' }
      controller.stub(:authorize)
      post :update, { id: user.id }.merge(@attrs)
      user.reload
    end

    it { expect(user.name).to eq(@attrs[:name]) }
    it { expect(user.email).to eq(@attrs[:email]) }
    it { expect(response).to redirect_to(root_url) }
    it { expect(flash[:notice]).to eq('Your profile has been updated.') }
    it { expect(controller).to have_received(:authorize).with(user) }
  end
end
