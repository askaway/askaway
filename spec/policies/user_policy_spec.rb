require 'spec_helper'

describe UserPolicy do
  let(:user) { FactoryGirl.stub(:user) }
  let(:other_user) { FactoryGirl.stub(:user) }

  ['edit', 'update'].each do |action_name|
    describe "##{action_name}?" do
      it_behaves_like 'a policy' do
        let(:action) { action_name }
        let(:good_set) { [user, user] }
        let(:bad_set) { [user, other_user]}
      end
    end
  end
end
