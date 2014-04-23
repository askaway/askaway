# == Schema Information
#
# Table name: candidates
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  email         :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  authorisation :string(255)
#  avatar        :string(255)
#

require 'spec_helper'

describe Candidate do
  pending "add some examples to (or delete) #{__FILE__}"
end
