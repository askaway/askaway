require 'rails_helper'

describe QuestionsController, :type => :controller do
  let(:user) { FactoryGirl.create(:user) }

  describe "GET trending" do
    it "succeeds" do
      expect(get :trending).to be_successful
    end
  end

  describe 'POST #create' do
    context 'as a user' do
      before { sign_in user }

      let(:request) { post :create, question: FactoryGirl.attributes_for(:question) }

      it { expect{request}.to change(Question, :count).by(1) }
      it { expect(request).to redirect_to(new_questions_path) }
    end
    context 'as a guest' do
      let(:request) { post :create, question: FactoryGirl.attributes_for(:question) }

      it { expect{request}.to change(Question, :count).by(1) }
    end
  end
end
