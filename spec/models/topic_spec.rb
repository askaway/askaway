require 'rails_helper'

describe Topic, :type => :model do
  it { is_expected.to have_many :questions }
  it { is_expected.to validate_presence_of :name }
end
