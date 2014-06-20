require 'policy_helper'

describe AnswerPolicy do
  subject { AnswerPolicy }
  let(:user) { FactoryGirl.create(:user) }
  let(:question) { FactoryGirl.create(:question) }
  let(:answer) { Answer.new(question: question) }

  permissions :create? do
    it 'permits rep to answer question' do
      FactoryGirl.create(:rep, user: user)
      user.reload
      expect(subject).to permit(user, answer)
    end

    it 'does not permit user to answer question' do
      allow(user).to receive(:is_rep?).and_return(false)
      expect(subject).not_to permit(user, answer)
    end

    context 'question has already been answered by a rep in the same party' do
      let(:answer) { FactoryGirl.create(:answer) }
      let(:user) { FactoryGirl.create(:user) }

      it 'does not permit rep to answer question' do
        FactoryGirl.create(:rep, user: user, party: answer.rep.party)
        user.reload
        expect(subject).not_to permit(user, Answer.new(question: answer.question))
      end
    end
  end
end
