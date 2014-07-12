# == Schema Information
#
# Table name: parties
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  auth_statement :string(255)
#  description    :text
#  created_at     :datetime
#  updated_at     :datetime
#

class Party < ActiveRecord::Base
  include FriendlyId
  def self.slug_candidate; :name; end
  friendly_id slug_candidate, :use => [:slugged, :history]
  include FriendlyIdHelper

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :auth_statement

  has_many :reps
  has_many :rep_users, through: :reps, source: :user

  def slug_candidate
    :name
  end

  def invitations
    Invitation.to_join_party(self)
  end

  def pending_invitations
    invitations.where(accepted_at: nil)
  end

  def full_name
    "The #{name}"
  end

  def unassigned_topics
    @_unassigned_topics ||= calculate_unassigned_topics
  end

  def assigned_topics
    @_assigned_topics ||= calculate_assigned_topics
  end

  private
    def calculate_assigned_topics
      # FIXME: this should be done in SQL to be performant
      topics = []
      reps.assigned.each do |rep|
        topics += rep.topics
      end
      topics
    end

    def calculate_unassigned_topics
      # FIXME: this should be done in SQL to be performant
      assigned = []
      reps.each do |rep|
        assigned = assigned + rep.topics
      end
      Topic.all - assigned
    end
end
