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
      title += " to join #{invitation.invitable.full_name}"
    end
    title
  end
end
