class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :party

  validates_uniqueness_of :user_id, scope: :party_id
end
