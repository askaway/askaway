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

  describe "#avatar_url" do
    context 'user has social media identity' do
      let(:identity) { FactoryGirl.create(:identity, uid: '12345', provider: 'twitter', user: user) }
      before { identity }
      it "returns social media picture" do
        expect(user.avatar_url).to eq('http://res.cloudinary.com/demo/image/twitter/w_64,h_64,c_fill/12345.jpg')
      end
      it 'returns gplus image for google_oauth2 provider' do
        identity.update_attribute(:provider, 'google_oauth2')
        expect(user.avatar_url).to eq('http://res.cloudinary.com/demo/image/gplus/w_64,h_64,c_fill/12345.jpg')
      end
      it 'ignores facebook for now (since it doesnt work with cloudinary)' do
        # TODO: check back with cloudinary on this
        identity.update_attribute(:provider, 'facebook')
        expect(user.avatar_url).not_to match(/facebook/)
      end
      context 'given a size' do
        it 'returns social media picture of given size' do
          expect(user.avatar_url(size: 32)).to eq('http://res.cloudinary.com/demo/image/twitter/w_32,h_32,c_fill/12345.jpg')
        end
      end
    end
    context 'user has no social media identity' do
      it "returns gravatar" do
        expect(user.avatar_url).to eq(user.gravatar_url + '&s=64')
      end
      context "given a size" do
        it "returns a gravatar picture of given size" do
          expect(user.avatar_url(size: 32)).to eq(user.gravatar_url(size: 32))
        end
      end
    end
    context 'user has no social media or gravatar' do
      it "returns animal picture"
      context 'given a size' do
        it 'returns animal picture of given size'
      end
    end
  end
end
