require 'active_support/concern'
module ProfanityFilter
  extend ActiveSupport::Concern

  included do
    include Workflow
    workflow do
      state :default do
        event :flag_for_review, :transitions_to => :awaiting_review
      end
      state :awaiting_review do
        event :accept, :transitions_to => :accepted
        event :reject, :transitions_to => :rejected
      end
      state :accepted
      state :rejected
    end

    scope :visible_to_public, -> { where("workflow_state IN ('default', 'accepted')") }
    scope :awaiting_review, -> { with_awaiting_review_state }

    before_create :check_for_obscenity
  end

  private
  def check_for_obscenity
    self.workflow_state = 'awaiting_review' if Obscenity.profane?(body)
  end
end
