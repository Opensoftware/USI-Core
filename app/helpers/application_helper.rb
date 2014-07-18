module ApplicationHelper

  def new_child_fields_template(form_builder, association, options = {})
    options[:object] ||= form_builder.object.class.reflect_on_association(association).klass.new
    options[:partial] ||= association.to_s.singularize
    options[:form_builder_local] ||= :b
    options[:options_for_partial] ||= {}
    options[:association_template_id] ||= "#{association}_fields_template"

    content_tag(:div, :id => options[:association_template_id], :style => "display: none") do
      form_builder.fields_for(association, options[:object], :child_index => "new_#{association}") do |f|
        render(:partial => options[:partial], :locals => { options[:form_builder_local] => f, :hidden => true }.merge!(options[:options_for_partial]))
      end
    end
  end

  def add_child_button(association, html_options)
    html_options["data-association"] = association
    html_options[:type] = :button
    content_tag(:button, html_options[:label], html_options)
  end

  def remove_child_button(form, html_options = {})
    html_options[:type] = :button
    form.hidden_field(:_destroy) + content_tag(:button, html_options[:label], html_options)
  end

  def render_flash_messages
    s = ''
    flash.each do |k,v|
      if [:notice, :warning, :error].include? k.to_sym
        if (v.is_a?(String) || v.is_a?(Symbol))
          s << render(:partial => "common/flash_#{k}_template", :locals => { :msg => v})
        elsif v.is_a?(Hash)
          v.each do |kk,vv|
            s << render(:partial => "common/flash_#{k}_template", :locals => { :msg => vv})
          end
        elsif v.is_a?(Array)
          v.each do |v|
            s << render(:partial => "common/flash_#{k}_template", :locals => { :msg => v})
          end
        end
      end
    end
    s.html_safe
  end

  def error_msgs_for(obj)
    if obj.errors.any?
      s = ''
      obj.errors.full_messages.uniq.each do |msg|
        s << render(:partial => "common/flash_form_error_template", :locals => { :msg => msg})
      end
      s.html_safe
    end
  end

  def annuals
    return @annuals if defined?(@annuals)
    @annuals = Annual.all
  end

  def semester_to_year_number(semester)
    case semester
    when 1,2 then 1
    when 3,4 then 2
    when 5,6 then 3
    when 7,8 then 4
    end
  end

  def disableable_button_tag(content_or_options, condition, options)
    options[:disabled] = true if condition
    button_tag(content_or_options, options)
  end

  def state_label(current_state)
    I18n.t "label_status_#{current_state}"
  end

  def format_status(status)
    color = case status.to_s
    when 'accepted' then
      'text-success'
    when 'rejected' then
      'text-danger'
    else
      ''
    end
    content_tag(:span, :class => color) do
      I18n.t "label_status_#{status}"
    end
  end

  def form_for_welcome_page
    if current_user
      form_for settings do |f|
        content_tag(:div, :class => 'main-page') do
          f.text_field :welcome_text
          content_tag(:div, :class => 'row') do
            f.submit :ble
          end
        end
      end
    else
      content_tag(:div, :class => 'main-page') do
        raw settings.welcome_text
      end
    end
  end

end
