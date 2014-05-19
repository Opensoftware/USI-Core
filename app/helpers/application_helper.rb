module ApplicationHelper

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

end
