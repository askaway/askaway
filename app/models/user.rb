# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  is_admin               :boolean          default(FALSE)
#  name                   :string(255)      not null
#

class User < ActiveRecord::Base
  include UploadedAvatar

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :google_oauth2, :twitter]

  validates_presence_of :name
  validates_presence_of :email
  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

  has_many :questions
  has_many :votes
  has_many :identities
  has_one :rep

  delegate :party, to: :rep, prefix: false

  def first_name
    name.split(" ")[0]
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  def is_rep?
    Rep.exists?(user_id: id)
  end

  def is_rep_for?(party)
    Rep.where(party: party, user: self).exists?
  end

  def can_administer?(party)
    is_admin? || is_rep_for?(party)
  end

  def can_embed?
    is_embedder? || is_admin?
  end

  def name_and_email
    "#{name} <#{email}>"
  end

  def can_answer?(question)
    is_rep? && !Question.has_answer_from_party?(question, party)
  end
end
