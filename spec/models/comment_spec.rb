require 'rails_helper'

describe Comment, :type => :model do
  it { is_expected.to belong_to(:question) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_presence_of(:body) }

  describe "profanity filter" do
    let(:dirty_comment) { FactoryGirl.create(:comment,
                    body: "Yo! What the fuck? This shit is krayyy!!") }
    let(:clean_comment) { FactoryGirl.create(:comment,
                    body: "I like rainbows. Do you? Meowww!!") }

    it "is marked as awaiting_review if it has profane words" do
      expect(dirty_comment).to be_awaiting_review
    end

    it 'is marked as default if no profane words' do
      expect(clean_comment).to be_default
      expect(clean_comment).not_to be_awaiting_review
    end
  end
end
