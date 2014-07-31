require 'active_support/concern'

module UploadedAvatar
  extend ActiveSupport::Concern

  PICTURE_SIZES = {xsmall: 32, small: 64}
  AVATAR_TYPES = %w(identity uploaded_avatar placeholder)

  included do
    belongs_to :selected_avatar_identity, class_name: 'Identity'

    has_attached_file :uploaded_avatar, :styles => { :xsmall => "32x32#", :small => "64x64#" }
    validates_attachment :uploaded_avatar,
      content_type: { content_type: /\Aimage\/.*\Z/ },
      size: { :in => 0..5.megabytes }

    validates_inclusion_of :selected_avatar_type, in: AVATAR_TYPES, allow_blank: true
    validate :owns_selected_avatar_identity

    before_create :set_placeholder_id
  end

  def avatar_selection_choices
    choices = []
    if identities.present?
      identities.order('provider ASC').each do |iden|
        name = iden.provider.capitalize
        name = 'Google' if iden.provider == 'google_oauth2'
        name = "#{name}"
        selection = { name: name, type: 'identity', identity: iden }
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

  def select_avatar!(type: nil, identity: nil, identity_id: nil)
    self.selected_avatar_type = type
    identity ||= Identity.find(identity_id) if identity_id
    if identity.present?
      self.selected_avatar_type = 'identity'
      self.selected_avatar_identity = identity
    end
    save
  end

  def avatar_url(size: :small)
    if selected_avatar_type.nil?
      selection = avatar_selection_choices.first.slice(:type, :identity)
      unless selection[:type] == 'placeholder'
        select_avatar!(selection)
      end
    end
    specific_avatar_url(type: selected_avatar_type,
                        identity: selected_avatar_identity,
                        size: size)
  end

  def specific_avatar_url(type: nil, identity: nil, size: :small)
    if type == 'identity'
      identity.image_url(size: size)
    elsif type == 'uploaded_avatar'
      uploaded_avatar.url(size)
    else
      placeholder_image_url(size: size)
    end
  end

  private
    def placeholder_image_url(size: :small)
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
