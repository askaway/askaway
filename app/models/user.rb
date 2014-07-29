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
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/
  PICTURE_SIZES = {small: 32, large: 64}
  AVATAR_TYPES = %w(identity uploaded_avatar placeholder)

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :google_oauth2, :twitter]

  has_attached_file :uploaded_avatar, :styles => { :small => "32x32#", :large => "64x64#" }, :default_url => "http://placekitten.com/64/64"
  validates_attachment_content_type :uploaded_avatar, :content_type => /\Aimage\/.*\Z/

  validates_presence_of :name
  validates_presence_of :email
  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update
  validates_inclusion_of :selected_avatar_type, in: AVATAR_TYPES, allow_blank: true
  validate :owns_selected_avatar_identity

  has_many :questions
  has_many :votes
  has_many :identities
  has_one :rep
  belongs_to :selected_avatar_identity, class_name: 'Identity'

  delegate :party, to: :rep, prefix: false

  before_create :set_placeholder_id

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

  def can_embed?
    is_embedder? || is_admin?
  end

  def name_and_email
    "#{name} <#{email}>"
  end

  def can_answer?(question)
    is_rep? && !Question.has_answer_from_party?(question, party)
  end

  def select_avatar!(type: nil, identity: nil)
    self.selected_avatar_type = type
    if identity.present?
      self.selected_avatar_type = 'identity'
      self.selected_avatar_identity = identity
    end
    save
  end

  def avatar_url(size: :large)
    if selected_avatar_type.nil?
      selection = avatar_selection_choices.first.slice(:type, :identity)
      unless selection[:type] == 'placeholder'
        select_avatar!(selection)
      end
    end
    if selected_avatar_type == 'identity'
      selected_avatar_identity.image_url(size: size)
    elsif selected_avatar_type == 'uploaded_avatar'
      uploaded_avatar.url(size)
    else
      placeholder_image_url(size: size)
    end
  end

  def avatar_selection_choices
    choices = []
    if identities.present?
      identities.order('provider ASC').each do |iden|
        name = iden.provider.capitalize
        name = 'Google' if iden.provider == 'google_oauth2'
        selection = { name: name, identity: iden }
        selection.merge!(selected: true) if is_selected?(identity: iden)
        choices << selection
      end
    end
    if uploaded_avatar.present?
      selection = { name: 'uploaded', type: 'uploaded_avatar'}
      selection.merge!(selected: true) if is_selected?(type: 'uploaded_avatar')
      choices << selection
    end
    selection = { name: 'random animal', type: 'placeholder'}
    selection.merge!(selected: true) if is_selected?(type: 'placeholder')
    choices << selection
  end

  private
    def placeholder_image_url(size: :large)
      width = PICTURE_SIZES.fetch(size)
      ActionController::Base.helpers.asset_path("placeholders/#{placeholder_id}-#{width}.jpeg");
    end

    def set_placeholder_id
      self.placeholder_id ||= rand(5)
    end

    def owns_selected_avatar_identity
      if selected_avatar_type == 'identity' && !identities.include?(selected_avatar_identity)
        errors.add(:selected_avatar_identity, "does not belong to user")
      end
    end

    def is_selected?(identity: nil, type: nil)
      if identity.present?
        (selected_avatar_type == 'identity') && (selected_avatar_identity == identity)
      else
        (selected_avatar_type == type) || (selected_avatar_type.nil? && type == 'placeholder')
      end
    end
end
