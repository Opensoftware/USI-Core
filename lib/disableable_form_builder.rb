class DisableableFormBuilder < ActionView::Helpers::FormBuilder

  def disableable_text_field(method, condition, options = {})
    disable(condition, options)
    text_field(method, options)
  end

  def disableable_text_area(method, condition, options = {})
    disable(condition, options)
    text_area(method, options)
  end

  def disableable_select(method, condition, choices, options = {}, html_options = {})
    disable(condition, html_options)
    select(method, choices, options, html_options)
  end

  def disableable_radio_button(method, condition, tag_value, options = {})
    disable(condition, options)
    radio_button(method, tag_value, options)
  end

  def disableable_checkbox(method, condition, options = {}, checked_value = "1", unchecked_value = "0")
    disable(condition, options)
    check_box(method, options, checked_value, unchecked_value)
  end



  private
  def disable(condition, options)
    if condition
      options[:disabled] = true
      options[:class] = "#{options[:class].to_s} force-visible"
    end
  end

end
