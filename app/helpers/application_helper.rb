module ApplicationHelper

  def image_url(source)
    URI.join(root_url, image_path(source))
  end

  def resource
    @resource ||= User.new
  end

  def create_account_title
    title = 'Create an account'
    if session[:invitation_token].present?
      invitation = Invitation.find_by(token: session[:invitation_token])
      title = "Join #{invitation.invitable.name}"
    end
    title
  end

  def upload_avatar_resource_path(resource)
    if resource.class.name == 'User'
      upload_avatar_user_path(resource)
    elsif resource.class.name == 'Party'
      upload_avatar_party_path(resource)
    end
  end
end
