module ApplicationHelper

  def facebook_button(question, send_btn=false)
    content_tag(:div, "", class: "fb-like", data: {'like-url' => like_question_path(question), href: facebook_link(question), width: 100, layout: :button_count, 'show-faces' => false, send: send_btn})
  end

  def facebook_link(obj)
    host = (Rails.env.development?) ? 'example.com' : ENV['CANONICAL_URL']
    # url_for polymorphic_path(obj, host: host, port: nil, format: :html, only_path: false)
    url_for polymorphic_path(obj, host: host, only_path: false)
  end

  def image_url(source)
    URI.join(root_url, image_path(source))
  end
end
