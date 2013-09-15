module ApplicationHelper

  def facebook_button(question)
    content_tag(:div, "", class: "fb-like", data: {'like-url' => like_question_path(question), href: facebook_link(question), width: 100, layout: :button_count, 'show-faces' => false, send: true})
  end

  def facebook_link(obj)
    host = (Rails.env.development?) ? 'example.com' : ENV['DEFAULT_URL_HOST']
    url_for polymorphic_path(obj, host: host, port: nil, format: :html, only_path: false)
  end

  def image_url(source)
    URI.join(root_url, image_path(source))
  end
end
