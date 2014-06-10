module ApplicationHelper

  def image_url(source)
    URI.join(root_url, image_path(source))
  end

  def resource
    @resource ||= User.new
  end
end
