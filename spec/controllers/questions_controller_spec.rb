require 'rails_helper'

describe QuestionsController, :type => :controller do
  let(:user) { FactoryGirl.create(:user) }
  let!(:question){ FactoryGirl.create(:question) }

  shared_examples 'index page' do
    it{ expect(response).to be_successful }
    it{ expect(response).to render_template(:index) }
    it{ expect(assigns(:questions)).to include(question)}
  end

  describe 'GET #trending' do
    before{ get :trending }
    it_behaves_like 'index page'
  end

  describe 'GET #new_questions' do
    before{ get :new_questions }
    it_behaves_like 'index page'
  end

  describe 'GET #most_votes' do
    before{ get :most_votes }
    it_behaves_like 'index page'
  end

  describe 'GET #recently_answered' do
    before{ get :recently_answered }
    it{ expect(response).to be_successful }
    it{ expect(response).to render_template(:index) }
  end

  context 'POST #create' do
    before { sign_in user }

    let(:request) { post :create, question: FactoryGirl.attributes_for(:question) }

    it { expect{request}.to change(Question, :count).by(1) }
    it { expect(request).to redirect_to(new_questions_path) }
  end
end
