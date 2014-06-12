require 'spec_helper'

describe CommentsController, :type => :controller do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:question) { FactoryGirl.create(:question) }
  let(:comment_attrs) do
    FactoryGirl.attributes_for(:comment, question: question)
  end

  describe '#create' do
    before { sign_in user }

    let(:request){ post :create, question_id: question, comment: comment_attrs }

    it{ expect(request).to redirect_to question_path(question)}
    it{ expect{request}.to change(Comment, :count).by(1) }
  end
end
