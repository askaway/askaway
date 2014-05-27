require 'spec_helper'

describe Question do
  let(:question) { FactoryGirl.build :question, :id => 1 }

  describe 'relations' do
    it { should have_many :answers }

    [:topic, :user].each do |attr|
      it { should belong_to attr }
    end
  end

  describe 'validations' do
    [:body, :user].each do |attr|
      it { should validate_presence_of attr }
    end

    it { should ensure_length_of(:body).is_at_most(140) }
  end

  describe "topic" do
    it 'defaults to nil' do
      question.topic.should == nil
    end

    it 'is set to General if none is chosen' do
      question.topic = nil
      question.save
      question.topic.name.should == 'General'
    end
  end

  describe "hotness" do
    it 'has 0 hotness with no votes' do
      expect(question.hotness).to eq(0)
    end

    it 'has 6 hotness with 64 votes' do
      question.vote_count = 64
      expect(question.hotness).to eq(6)
    end

    it 'has 12 hotness with 64 votes and id 64' do
      question.vote_count = 64
      question.id = 64
      expect(question.hotness).to eq(12)
    end
  end
end
