# This shared set of specs for Policies takes:
#
#   action:   Name of action you're testing for the policy (e.g 'edit')
#
#   good_set: A set of params the policy takes which should evaluate true.
#             As in, conditions which should pass authorization.
#
#   bad_set:  A set of params the policy takes which should evaluate false.
#             As in, conditions which should not pass authorization.
#
# At some point, we may need to expand to this to be able to include multiple sets.
#
RSpec.shared_examples 'a policy' do
  context 'granting authorization' do
    let(:policy) { UserPolicy.new(*good_set) }
    it { expect(policy.public_send(action+'?')).to eq(true) }
  end

  context 'not granting authorization' do
    let(:policy) { UserPolicy.new(*bad_set) }
    it { expect(policy.public_send(action+'?')).to eq(false) }
  end
end

