require 'spec_helper'

describe Party do
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should validate_presence_of(:auth_statement) }
end
