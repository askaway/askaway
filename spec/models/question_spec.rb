require 'spec_helper'

describe Question do
  let(:question) { FactoryGirl.build :question }

  describe 'relations' do
    it { should have_many :answers }
    it { should belong_to :topic }
  end

  describe 'validations' do
    [:body, :email, :name].each do |attr|
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
end
