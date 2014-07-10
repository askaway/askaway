# == Schema Information
#
# Table name: invitations
#
#  id             :integer          not null, primary key
#  email          :string(255)
#  name           :string(255)
#  inviter_id     :string(255)
#  intent         :string(255)
#  invitable_id   :integer
#  invitable_type :string(255)
#  acceptor_id    :integer
#  accepted_at    :datetime
#  token          :string(255)      not null
#  created_at     :datetime
#  updated_at     :datetime
#

class Invitation < ActiveRecord::Base
  class InvitationAlreadyAccepted < StandardError; end

  belongs_to :inviter, class_name: 'User'
  belongs_to :invitable, polymorphic: true

  validates :token, uniqueness: true

  validates :inviter_id, presence: true
  validates :name, presence: true
  validates :email, presence: true
  validates :intent, presence: true

  before_validation :set_token, on: [:create, :save]
  after_create :send_invitation

  scope :to_join_party, ->(party) {
    where(invitable_id: party.id).
    where(invitable_type: 'Party').
    where(intent: 'to_join_party')
  }

  scope :unaccepted, -> { where(accepted_at: nil) }

  def self.batch_invite!(emails: emails,
                         intent: intent,
                         invitable: invitable,
                         inviter: inviter)
    emails = process_emails(emails)
    return false if emails.blank?
    invitations = []
    emails.each do |address|
      invitations << create!(email: address.address,
                             name: address.display_name,
                             intent: intent,
                             invitable: invitable,
                             inviter: inviter)
    end
    invitations
  end

  def accept!(acceptor)
    raise Invitation::InvitationAlreadyAccepted if accepted?
    rep = Rep.new(party: invitable, user: acceptor)
    raise Invitation::InvitationAlreadyAccepted unless rep.valid?
    rep.save!
    update_attributes(accepted_at: Time.zone.now,
                      acceptor_id: acceptor.id)
  end

  def accepted?
    accepted_at.present?
  end

  def to_param
    token
  end

  private
    def self.process_emails(emails)
      begin
        raw_addresses = Mail::AddressList.new(emails)
      rescue Mail::Field::ParseError
        return false
      end
      return raw_addresses.addresses
    end

    def set_token
      self.token ||= SecureRandom.urlsafe_base64
    end

    def send_invitation
      InvitationMailer.send(intent, self).deliver
    end
end
