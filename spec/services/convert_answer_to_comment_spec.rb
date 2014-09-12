require 'rails_helper'

describe "ConvertAnswerToComment" do
  describe ".execute(answer)" do
    let(:answer) { FactoryGirl.create(:answer) }
    subject { ConvertAnswerToComment.execute(answer) }

    it { expect(subject).to be_a(Comment) }
    it { expect(subject).to be_persisted }
    it { expect(subject.body).to eq(answer.body) }
    it { expect(subject.user).to eq(answer.rep.user) }
    it { expect(subject.question).to eq(answer.question) }
    it { expect(subject.created_at).to eq(answer.created_at) }
    it 'deletes the answer' do
      subject
      expect{ answer.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
