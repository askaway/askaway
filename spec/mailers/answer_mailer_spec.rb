require "rails_helper"

RSpec.describe AnswerMailer, :type => :mailer do
  let(:asker) { FactoryGirl.build_stubbed(:user) }
  let(:question) { FactoryGirl.build_stubbed(:question, user: asker) }
  let(:rep) { FactoryGirl.build_stubbed(:rep) }
  let(:answer) { FactoryGirl.build_stubbed(:answer, question: question, rep: rep) }

  describe '#asker_notification' do
    subject { AnswerMailer.asker_notification(answer) }
    it { expect(subject.subject).to eq("Your question has been answered by the #{rep.party.name}") }
    it { expect(subject.body.encoded).to include("Hi #{asker.name}")}
  end
end
