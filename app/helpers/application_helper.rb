module ApplicationHelper

  def hide_breadcrumbs?
    controller_name == 'registrations' || action_name == 'who' || action_name == 'index'
  end
end
