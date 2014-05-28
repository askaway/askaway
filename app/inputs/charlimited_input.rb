class CharlimitedInput < SimpleForm::Inputs::TextInput
  def input(wrapper_options)
    result = super
    result += template.content_tag(:span, '', id: 'js-body-count')
  end
end
