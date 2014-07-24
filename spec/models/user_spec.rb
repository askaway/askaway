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

  describe 'avatar stuff' do
    describe '#avatar_selection_choices' do
      before do
        user.uploaded_avatar = StringIO.new('test.jpeg')
        user.uploaded_avatar_content_type = 'image/jpeg'
        user.save!
      end
      context 'user has twitter & facebook identity and uploaded avatar' do
        it 'returns twitter, facebook, uploaded, and placeholder choice' do
          tw_iden = FactoryGirl.create(:identity, provider: 'twitter', user: user)
          fb_iden = FactoryGirl.create(:identity, provider: 'facebook', user: user)
          user.select_avatar(identity: fb_iden)
          expect(user.avatar_selection_choices).to eq(
            [{name: 'Facebook', identity: fb_iden, selected: true},
             {name: 'Twitter', identity: tw_iden},
             {name: 'uploaded', type: 'uploaded_avatar'},
             {name: 'random animal', type: 'placeholder'}])
        end
      end
      context 'user has uploaded avatar' do
        it 'returns uploaded and placeholder choice' do
          user.select_avatar(type: 'uploaded_avatar')
          expect(user.avatar_selection_choices).to eq(
            [{name: 'uploaded', type: 'uploaded_avatar', selected: true},
             {name: 'random animal', type: 'placeholder'}])
        end
      end
      context 'user has nothing' do
        before do
          user.uploaded_avatar.clear
          user.save!
        end
        it 'returns placeholder choice' do
          expect(user.avatar_selection_choices).to eq(
            [{name: 'random animal', type: 'placeholder', selected: true}])
        end
      end
    end

    describe '#selected_avatar_type=' do
      it 'only allows specified types' do
        user.selected_avatar_type = 'goo'
        expect{ user.valid? }.to change{ user.errors[:selected_avatar_type] }.
          to include("is not included in the list")
        user.selected_avatar_type = 'identity'
        expect{ user.valid? }.to change{ user.errors[:selected_avatar_type] }.
          to eq([])
      end
    end

    describe "#select_avatar" do
      context 'user tries to select identity that doesnt belong to them' do
        it 'adds error to selected_avatar_identity' do
          identity = FactoryGirl.create(:identity)
          user.select_avatar(identity: identity)
          expect{ user.valid? }.to change{ user.errors[:selected_avatar_identity] }.
            to include("does not belong to user")
        end
      end
    end

    describe "#avatar_url" do
      context 'user has selected identity' do
        let(:identity) { FactoryGirl.create(:identity, uid: '12345', provider: 'twitter', user: user) }
        before { user.select_avatar(identity: identity) }
        it "returns identity.image_url" do
          expect(user.avatar_url(size: :small)).to eq(identity.image_url(size: :small))
        end
      end
      context 'user has selected uploaded_avatar' do
        before do
          user.uploaded_avatar = StringIO.new('test.jpeg')
          user.uploaded_avatar_content_type = 'image/jpeg'
          user.select_avatar(type: 'uploaded_avatar')
          user.save!
        end
        it "returns uploaded_avatar" do
          expect(user.avatar_url).to match('/system/users/uploaded_avatars/')
        end
        context 'given a size' do
          it 'returns uploaded_avatar of given size' do
            expect(user.avatar_url(size: :small)).to match('/system/users/uploaded_avatars/.+/small')
          end
        end
      end
      context 'user has not selected an avatar' do
        before { user.update_attribute(:placeholder_id, 2) }
        it "returns placeholder picture" do
          expect(user.avatar_url).to eq('/assets/placeholders/2-64.jpeg')
        end
        context 'given a size' do
          it 'returns placeholder picture of given size' do
            expect(user.avatar_url(size: :small)).to eq('/assets/placeholders/2-32.jpeg')
          end
        end
      end
    end
  end
end
