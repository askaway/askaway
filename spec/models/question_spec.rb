require 'spec_helper'

describe Question do
  let(:question) { FactoryGirl.create :question }
  let(:mailer) { double(deliver: true) }

  it "defaults to pending status" do
    question.should be_pending
  end

  describe "#accept!" do
    it "marks the question accepted" do
      question.accept!
      question.reload
      question.should be_accepted
    end
    it "sends an email to the asker" do
      QuestionMailer.stub(question_accepted: mailer)
      mailer.should_receive(:deliver)
      question.accept!
    end
    it "does not do anything if already accepted" do
      question.accept!
      question.should_not_receive(:update_attribute)
      QuestionMailer.should_not_receive(:question_accepted)
      question.accept!
    end
  end

  describe "#pending?" do
    it "returns true if status is pending" do
      question.status = "pending"
      question.should be_pending
    end
    it "returns false if status is not pending" do
      question.status = "something else"
      question.should_not be_pending
    end
  end

  describe "#accepted?" do
    it "returns true if status is accepted" do
      question.status = "accepted"
      question.should be_accepted
    end
    it "returns false if status is not accepted" do
      question.status = "something else"
      question.should_not be_accepted
    end
  end
end
