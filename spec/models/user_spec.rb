require 'rails_helper'

describe User, :type => :model do
  let(:user) { FactoryGirl.create(:user) }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to have_many :questions }
  it { is_expected.to have_one :rep }

  describe '#is_rep_for?(party)' do
    let(:party) { FactoryGirl.create(:party) }

    it 'returns true if user is a rep for the party' do
      rep = FactoryGirl.create(:rep, party: party, user: user)
      expect(user.is_rep_for?(party)).to be true
    end

    it 'returns false if user is not rep for the party' do
      expect(user.is_rep_for?(party)).to be false
    end
  end

end
