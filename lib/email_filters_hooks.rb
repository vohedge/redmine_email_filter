class EmailFiltersHooks < Redmine::Hook::ViewListener
  # Add CSS class
  def view_layouts_base_html_head(_context = {})
    stylesheet_link_tag 'email_filters.css', plugin: 'redmine_email_filter'
  end

  # Add Javascript class
  def view_layouts_base_body_bottom(_context = {})
    # javascript_include_tag 'email_filters.js', plugin: 'redmine_email_filter'
  end
end

