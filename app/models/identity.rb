class Identity < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  after_destroy :update_user_image

  def image_url(size: :large)
    width = User::PICTURE_SIZES.fetch(size)
    if provider == 'facebook'
      "https://graph.facebook.com/#{uid}/picture?width=#{width}&height=#{width}"
    elsif provider == 'twitter'
      "https://res.cloudinary.com/demo/image/twitter/w_#{width},h_#{width},c_fill/#{uid}.jpg"
    elsif provider == 'google_oauth2'
      "https://res.cloudinary.com/demo/image/gplus/w_#{width},h_#{width},c_fill/#{uid}.jpg"
    end
  end

  private
    def update_user_image
      user.update_attribute(:selected_avatar_type, nil)
      user.update_attribute(:selected_avatar_identity, nil)
    end
end
