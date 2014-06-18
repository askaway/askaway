class CharlimitedInput < SimpleForm::Inputs::TextInput
  def input(wrapper_options)
    result = super
    result += template.content_tag( :span, '{{ 140 - question.length }}', class: 'char-counter' )
  end
end
