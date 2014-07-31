require 'rails_helper'

describe Identity, :type => :model do
  let(:identity) { FactoryGirl.create(:identity, uid: '12345', provider: 'twitter') }

  describe "#image_url" do
    it 'returns twitter image' do
      expect(identity.image_url).to eq('https://res.cloudinary.com/demo/image/twitter/w_64,h_64,c_fill/12345.jpg')
    end
    it 'returns gplus image' do
      identity.update_attribute(:provider, 'google_oauth2')
      expect(identity.image_url).to eq('https://res.cloudinary.com/demo/image/gplus/w_64,h_64,c_fill/12345.jpg')
    end
    it 'returns facebook image' do
      identity.update_attribute(:provider, 'facebook')
      expect(identity.image_url).to eq('https://graph.facebook.com/12345/picture?width=64&height=64')
    end
    context 'given size: :xsmall' do
      it 'returns picture of size 32' do
        expect(identity.image_url(size: :xsmall)).to eq('https://res.cloudinary.com/demo/image/twitter/w_32,h_32,c_fill/12345.jpg')
      end
    end
    context 'given size 31' do
      it 'raises error because only certain sizes are allowed' do
        expect{identity.image_url(size: 31)}.to raise_error
      end
    end
  end

  describe 'after destroy' do
    it 'deletes user references to identity image' do
      user = identity.user
      user.avatar_url # loads the identity image
      expect(user.selected_avatar_type).to eq('identity')
      expect(user.selected_avatar_identity).to eq(identity)
      identity.destroy!
      expect(user.selected_avatar_type).to eq(nil)
      expect(user.selected_avatar_identity).to eq(nil)
    end
  end
end
