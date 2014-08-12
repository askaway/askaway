require 'rails_helper'

describe Question, :type => :model do
  let(:question) { FactoryGirl.build :question }
  #FIXME is there a better way of adding 4.5million seconds? from http://stackoverflow.com/questions/10056066/time-manipulation-in-ruby
  let(:hot_q) { FactoryGirl.create :question, :created_at => DateTime.new(2014, 1, 1) + Rational(10 * 450000, 86400), :votes_count => 64 }
  let(:cool_q) { FactoryGirl.create :question, :created_at => DateTime.new(2014, 1, 1), :votes_count => 64 }
  let(:cold_q) { FactoryGirl.create :question, :created_at => DateTime.new(2014, 1, 1), :votes_count => 0 }

  describe '#destroy' do
    [:answer, :comment, :vote].each do |association|
      it "destroys #{association}s" do
        association = FactoryGirl.create(association)
        association.question.destroy
        expect{association.reload}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'relations' do
    it { is_expected.to have_many :answers }

    [:topic, :embedded_topic, :user].each do |attr|
      it { is_expected.to belong_to attr }
    end
  end

  describe 'validations' do
    [:body, :user].each do |attr|
      it { is_expected.to validate_presence_of attr }
    end

    it { is_expected.to ensure_length_of(:body).is_at_most(140) }
  end

  describe ".has_answer_from_party?(question, party)" do
    let(:rep) { FactoryGirl.create(:rep) }
    let(:question) { FactoryGirl.create(:question) }

    it 'returns false if no rep from the party has answered the question' do
      expect(Question.has_answer_from_party?(question, rep.party)).to eq(false)
    end

    it 'returns true if a rep from the party has answered the question' do
      rep2 = FactoryGirl.create(:rep, party: rep.party)
      answer = FactoryGirl.create(:answer, question: question, rep: rep2)
      expect(Question.has_answer_from_party?(question, rep.party)).to eq(true)
    end
  end

  describe "hotness" do
    before do
      Setting.set(:time_weight, 450000)
      Setting.set(:answer_weight, 0)
    end

    it 'has 0 hotness with no votes' do
      expect(cold_q.hotness).to eq(0)
    end

    it 'has 6 hotness with 64 votes' do
      expect(cool_q.hotness).to eq(6)
    end

    it 'has 12 hotness with 64 votes and created_at 4.5 million seconds' do
      expect(hot_q.hotness).to eq(16)
    end
  end

  describe "profanity filter" do
    let(:dirty_q) { FactoryGirl.create(:question,
                    body: "Yo! What the fuck? This shit is krayyy!!") }
    let(:clean_q) { FactoryGirl.create(:question,
                    body: "I like rainbows. Do you? Meowww!!") }

    it "is marked as awaiting_review if it has profane words" do
      expect(dirty_q).to be_awaiting_review
    end

    it 'is marked as default if no profane words' do
      expect(clean_q).to be_default
      expect(clean_q).not_to be_awaiting_review
    end
  end

  context 'awaiting_review' do
    before do
      @question = FactoryGirl.create(:question)
      @question.flag_for_review!
    end

    it 'can be accepted' do
      @question.accept!
      expect(@question).to be_accepted
    end

    it 'updates created_at after being accepted' do
      Timecop.freeze(Date.today + 1)
      question2 = FactoryGirl.create(:question)
      Timecop.freeze(Date.today + 2)
      @question.accept!
      Timecop.return
      expect(@question.reload.created_at).to be > question2.created_at
    end

    it 'can be rejected' do
      @question.reject!
      expect(@question).to be_rejected
    end
  end
end
