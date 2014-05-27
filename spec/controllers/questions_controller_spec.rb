require 'spec_helper'

describe QuestionsController do
  let(:user) { FactoryGirl.create(:user) }

  describe "GET trending" do
    it "succeeds" do
      expect(get :trending).to be_successful
    end
  end

  context 'POST #create' do
    before { sign_in user }

    let(:request) { post :create, question: FactoryGirl.attributes_for(:question) }

    it { expect{request}.to change(Question, :count).by(1) }
    it { expect(request).to redirect_to(new_questions_path) }
  end
end
