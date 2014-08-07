require 'rails_helper'

describe 'UploadedAvatar' do
  let(:user) { FactoryGirl.create(:user) }
  let(:placeholder) { FactoryGirl.create(:placeholder) }

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
        user.select_avatar!(identity: fb_iden)
        expect(user.avatar_selection_choices).to eq(
          [{name: 'Facebook', identity: fb_iden, type: 'identity', selected: true},
           {name: 'Twitter', identity: tw_iden, type: 'identity'},
           {name: 'uploaded', type: 'uploaded_avatar'},
           {name: 'random animal', type: 'placeholder'}])
      end
    end
    context 'user has uploaded avatar' do
      it 'returns uploaded and placeholder choice' do
        user.select_avatar!(type: 'uploaded_avatar')
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

  describe "#select_avatar!" do
    context 'user tries to select identity that doesnt belong to them' do
      it 'adds error to selected_avatar_identity' do
        identity = FactoryGirl.create(:identity)
        user.select_avatar!(identity: identity)
        expect(user.errors[:selected_avatar_identity]).
          to include("does not belong to user")
      end
    end
  end

  describe "#avatar_url" do
    context 'user has not selected an avatar' do
      it "returns placeholder picture, but does not select it" do
        placeholder
        user.update_attribute(:placeholder_id, placeholder.id)
        expect(user.avatar_url).to eq(placeholder.uploaded_avatar.url(:small))
        user.reload
        expect(user.selected_avatar_type).to be_nil
      end
      it "returns (and selects) identity.image_url if user has identity" do
        identity = FactoryGirl.create(:identity, uid: '12345', provider: 'twitter', user: user)
        expect(user.avatar_url).to eq(identity.image_url)
        user.reload
        expect(user.selected_avatar_type).to eq('identity')
        expect(user.selected_avatar_identity).to eq(identity)
      end
      it "returns (and selects) uploaded_avatar if user has one" do
        user.uploaded_avatar = StringIO.new('test.jpeg')
        user.uploaded_avatar_content_type = 'image/jpeg'
        user.save!
        expect(user.avatar_url).to match('/system/users/uploaded_avatars/')
        user.reload
        expect(user.selected_avatar_type).to eq('uploaded_avatar')
      end
    end

    context 'user has selected an avatar' do
      before do
        user.uploaded_avatar = StringIO.new('test.jpeg')
        user.uploaded_avatar_content_type = 'image/jpeg'
        user.save!
        @identity = FactoryGirl.create(:identity, uid: '12345', provider: 'twitter', user: user)
      end
      it 'returns identity.image url if selected' do
        user.select_avatar!(identity: @identity)
        expect(user.avatar_url).to eq(@identity.image_url)
        expect(user.avatar_url(size: :xsmall)).to eq(@identity.image_url(size: :xsmall))
      end
      it 'returns uploaded_avatar url if selected' do
        user.select_avatar!(type: 'uploaded_avatar')
        expect(user.avatar_url).to match('/system/users/uploaded_avatars/.+/small')
        expect(user.avatar_url(size: :xsmall)).to match('/system/users/uploaded_avatars/.+/xsmall')
      end
      it 'returns placeholder url if selected' do
        user.select_avatar!(type: 'placeholder')
        user.update_attribute(:placeholder_id, placeholder.id)
        expect(user.avatar_url).to eq(placeholder.uploaded_avatar.url(:small))
        expect(user.avatar_url(size: :xsmall)).to eq(placeholder.uploaded_avatar.url(:xsmall))
      end
    end
  end
end
