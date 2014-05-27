module ApplicationHelper

  def image_url(source)
    URI.join(root_url, image_path(source))
  end
end
