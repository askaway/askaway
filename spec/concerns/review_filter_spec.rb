require 'rails_helper'

describe ReviewFilter do
  describe "profane content filter" do
    shared_examples "filtered when has profane words" do
      let(:body) { "Yo! What the fuck? This shit is krayyy!!" }
      it { is_expected.to be_awaiting_review }
    end

    shared_examples "pass when no profane words" do
      let(:body) { "I like rainbows. Do you? Meowww!!" }
      it { is_expected.to be_default }
      it { is_expected.not_to be_awaiting_review }
    end

    context Question do
      subject { FactoryGirl.create(:question, body: body) }
      it_behaves_like "filtered when has profane words"
      it_behaves_like "pass when no profane words"
    end

    context Comment do
      subject { FactoryGirl.create(:comment, body: body) }
      it_behaves_like "filtered when has profane words"
      it_behaves_like "pass when no profane words"
    end
  end

  describe "moderated user filter" do
    let(:user) { FactoryGirl.create(:user, under_moderation: under_moderation) }

    shared_examples "filtered when under moderation" do
      let(:under_moderation){ true }
      it { is_expected.to be_awaiting_review }
    end

    shared_examples "pass when not under moderation" do
      let(:under_moderation){ false }
      it { is_expected.to be_default }
      it { is_expected.not_to be_awaiting_review }
    end

    context Question do
      subject { FactoryGirl.create(:question, user: user) }
      it_behaves_like "filtered when under moderation"
      it_behaves_like "pass when not under moderation"
    end

    context Comment do
      subject { FactoryGirl.create(:comment, user: user) }
      it_behaves_like "filtered when under moderation"
      it_behaves_like "pass when not under moderation"
    end
  end
end
