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

  def facebook_link(question)
    host = (Rails.env.development?) ? 'example.com' : nil
    url_for question_path(question, host: host, port: nil, only_path: false)
  end
end
