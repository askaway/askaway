require 'rails_helper'

RSpec.describe Rep, :type => :model do
  it { is_expected.to validate_uniqueness_of(:user_id) }
end
