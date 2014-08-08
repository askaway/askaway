class Placeholder < ActiveRecord::Base
  has_attached_file :uploaded_avatar,
    :styles => User.avatar_styles,
    :s3_protocol => :https
  validates_attachment :uploaded_avatar,
    content_type: { content_type: /\Aimage\/.*\Z/ },
    size: { :in => 0..5.megabytes }

  def select_avatar!(type: nil)
    save
  end
end
