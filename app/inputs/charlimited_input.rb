class CharlimitedInput < SimpleForm::Inputs::TextInput
  def input(wrapper_options)
    result = super
    result += template.content_tag(:charcounter, nil,
              {for_model: ng_model_name, maxlength: maxlength})
  end

  def html_options_for(namespace, css_classes)
    super.merge(ng_model: ng_model_name, maxlength: maxlength)
  end

  private
    def ng_model_name
      "#{@builder.object_name + attribute_name.to_s.capitalize}Input"
    end

    def maxlength
      @maxlength ||= eval("#{@builder.object.class}::#{attribute_name.to_s.upcase}_MAX_LENGTH")
    end
end
