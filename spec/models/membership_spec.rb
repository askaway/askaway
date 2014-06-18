require 'rails_helper'

RSpec.describe Membership, :type => :model do
  it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:party_id) }
end
