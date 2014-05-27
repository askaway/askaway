require 'spec_helper'

describe Topic do
  it { should have_many :questions }
  it { should validate_presence_of :name }
end
