require 'rails_helper'

describe UsersController, :type => :controller do
  let(:user) { FactoryGirl.create(:user) }

  describe 'GET #edit' do
    let(:response) { get :edit, id: user.id }

    context 'logged in' do
      before { sign_in user }

      it { expect(response).to render_template(:edit) }
    end

    context 'logged out' do
      it { expect(response).to redirect_to(new_user_session_url) }
    end
  end

  describe 'PATCH #update' do
    let(:response) { patch :update, id: user.id, user: attrs }
    let(:attrs) { { name: 'new name', email: 'new@email.com' } }

    context 'logged in' do
      before do
        sign_in user
        response
        user.reload
      end

      it { expect(user.name).to eq(attrs[:name]) }
      it { expect(user.email).to eq(attrs[:email]) }
      it { expect(response).to redirect_to(root_url) }
      it { expect(flash[:notice]).to eq('Your profile has been updated.') }
    end

    context 'logged out' do
      it { expect(response).to redirect_to(new_user_session_url) }
    end
  end

  describe "GET #show" do
    before { get :show, id: user.slug }

    it { expect(assigns(:user)).to eq(user) }
    it { expect(response).to render_template(:show) }
  end
end
