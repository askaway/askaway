module QuestionsHelper
  def asked_by(object)
    "Asked by #{object.name.titleize} on #{object.created_at.strftime("%b %-d")}"
  end

  def facebook_button(object)
    content_tag(:div, "", class: "fb-like", data: {href: facebook_link(object), width: 100, layout: :button_count, 'show-faces' => false, send: true})
  end

  def facebook_link(question)
    host = (Rails.env.development?) ? 'example.com' : nil
    url_for question_path(question, host: host, port: nil, only_path: false)
  end
end
