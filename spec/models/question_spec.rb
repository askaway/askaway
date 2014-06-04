require 'spec_helper'

describe Question do
  let(:question) { FactoryGirl.build :question }
  #FIXME is there a better way of adding 4.5million seconds? from http://stackoverflow.com/questions/10056066/time-manipulation-in-ruby
  let(:hot_q) { FactoryGirl.create :question, :created_at => DateTime.new(2014, 1, 1) + Rational(10 * 450000, 86400), :votes_count => 64 }
  let(:cool_q) { FactoryGirl.create :question, :created_at => DateTime.new(2014, 1, 1), :votes_count => 64 }
  let(:cold_q) { FactoryGirl.create :question, :created_at => DateTime.new(2014, 1, 1), :votes_count => 0 }

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
      expect(cold_q.hotness).to eq(0)
    end

    it 'has 6 hotness with 64 votes' do
      expect(cool_q.hotness).to eq(6)
    end

    it 'has 12 hotness with 64 votes and created_at 4.5 million seconds' do
      expect(hot_q.hotness).to eq(16)
    end
  end
end
