module ApplicationHelper

  def hide_breadcrumbs?
    controller_name == 'registrations' || action_name == 'who' || action_name == 'index'
  end

  def hide_footer?
    (controller_name == 'index' && action_name == 'index') || action_name == 'who'
  end

  def is_url?(string)
    string.include?('http://') || string.include?('https://')
  end

  def cut_text(text, size)
    text.size <= size ? text : "#{text[0..size-1]}..."
  end

  def localize_time(time)
    if I18n.locale == :en
      time = time.strftime("%I %p")
      time[0] = '' if time[0] == '0'
      time
    else
      time.strftime("%H:00")
    end
  end
end
