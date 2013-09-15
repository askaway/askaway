module QuestionsHelper
  def asked_by(question)
    if question.is_anonymous?
      "Asked by anonymous on #{question.created_at.strftime("%b %-d")}"
    else
      "Asked by #{question.name.titleize} on #{question.created_at.strftime("%b %-d")}"
    end
  end

  def facebook_button(question)
    content_tag(:div, "", class: "fb-like", data: {'like-url' => like_question_path(question), href: facebook_link(question), width: 100, layout: :button_count, 'show-faces' => false, send: true})
  end

  def facebook_link(obj)
    host = (Rails.env.development?) ? 'example.com' : ENV['DEFAULT_URL_HOST']
    url_for polymorphic_path(obj, host: host, port: nil, only_path: false)
  end
end
