require 'rails_helper'

describe "FriendlyIdHelper" do
  let(:user) { FactoryGirl.create(:user) }

  # FIXME: technically we should be defining a generic
  #        class here to test FriendlyIdHelper with
  #        instead of using Question. But I couldn't find
  #        an easy way of doing that. (-JL)
  describe 'slugs' do
    it 'increments duplicate questions nicely' do
      body = "Hey there, what's up?"
      body_slugged = body.parameterize
      q = FactoryGirl.create(:question, body: body)
      q2 = FactoryGirl.create(:question, body: body)
      q3 = FactoryGirl.create(:question, body: body)
      expect(q.slug).to eq(body_slugged)
      expect(q2.slug).to eq(body_slugged + '-2')
      expect(q3.slug).to eq(body_slugged + '-3')
    end

    it 'truncates after 13 words or 80 characters' do
      body = "Hey there, what's up? This is going to be a very long question. Yes indeed"
      body2 = "Hey there, what's up? This
      belklsafjslkfjslafjaslkfjsadflakssfaljslkdfjasdflkadjsf
      is going to be a very long question"
      q = FactoryGirl.create(:question, body: body)
      q2 = FactoryGirl.create(:question, body: body2)
      expect(q.slug).to eq("hey-there-what-s-up-this-is-going-to-be-a-very-long-question")
      expect(q2.slug).to eq("hey-there-what-s-up-this-belklsafjslkfjslafjaslkfjsadflakssfaljslkdfjasdflkadjs")
    end
  end
end
