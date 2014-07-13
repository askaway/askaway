require 'rails_helper'

describe Party, :type => :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
  it { is_expected.to validate_presence_of(:auth_statement) }
  it { is_expected.to have_many(:reps) }
  it { is_expected.to have_many(:rep_users).through(:reps).source(:user) }

  describe '#unassigned_topics' do
    it 'returns topics that are not assigned to any reps in the party' do
      party = FactoryGirl.create(:party)
      rep1 = FactoryGirl.create(:rep, party: party)
      topic1 = FactoryGirl.create(:topic)
      topic2 = FactoryGirl.create(:topic)
      topic3 = FactoryGirl.create(:topic)
      FactoryGirl.create(:rep_topic, rep: rep1, topic: topic1)
      expect(party.unassigned_topics).not_to include(topic1)
      expect(party.unassigned_topics).to include(topic2)
      expect(party.unassigned_topics).to include(topic3)
    end
  end

  describe "#assigned_topics" do
    it 'returns topics assigned to reps in the party' do
      party = FactoryGirl.create(:party)
      rep1 = FactoryGirl.create(:rep, party: party)
      topic1 = FactoryGirl.create(:topic)
      topic2 = FactoryGirl.create(:topic)
      topic3 = FactoryGirl.create(:topic)
      FactoryGirl.create(:rep_topic, rep: rep1, topic: topic1)
      FactoryGirl.create(:rep_topic, rep: rep1, topic: topic2)
      expect(party.assigned_topics).to include(topic1)
      expect(party.assigned_topics).to include(topic2)
      expect(party.assigned_topics).not_to include(topic3)
    end
  end
end
